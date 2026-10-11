"""radar_link.py : Packet format of the PC <-> KV260 (PS) link.

Purpose:  Packs and unpacks the UDP packets that carry the radar data.
          Spec: docs/ETHERNET_PROTOKOLU.md

Packets (all little endian, 16 byte header):
    CONFIG  PC -> board : TX pulse coefficients (Q2.14) and chain parameters
    RX      PC -> board : samples of one PRI, 4 packets of 250 samples
    RESULT  board -> PC : detections of one CPI
"""
import struct

MAGIC = 0x5241                      # 'RA'
VERSION = 1

T_CONFIG, T_RX, T_RESULT = 1, 2, 3

F_FIRST = 0x1                       # RX: first packet of a CPI
F_LAST = 0x2                        # RX: last packet of a CPI
F_INCOMPLETE = 0x1                  # RESULT: packets of the CPI were missing, result is not valid

N_PRI = 1000                        # samples in one PRI
N_PULSE = 20                        # PRI count in one CPI
N_PULSE_SAMPLE = 20                 # samples of the TX pulse
SAMPLES_PER_PACKET = 250            # 4 packets per PRI, 1016 byte UDP payload (fits 1500 MTU)
PACKETS_PER_PRI = N_PRI // SAMPLES_PER_PACKET
PACKETS_PER_CPI = PACKETS_PER_PRI * N_PULSE
MAXDET = 16

# magic, version, type, cpi_id, pri_idx, seg, count, flags
HEADER = struct.Struct('<HBBIHHHH')
# n_pri, n_pulse, n_pulse_sample, nfft, num_ref, num_guard, k, threshold_factor, max_gap, peak_ratio_q8
CONFIG_PARAMS = struct.Struct('<10H')
# count, overflow, idx[MAXDET], latency_cycles
RESULT_BODY = struct.Struct('<HH%dHI' % MAXDET)


def _header(ptype, cpi_id, pri_idx, seg, count, flags):
    return HEADER.pack(MAGIC, VERSION, ptype, cpi_id, pri_idx, seg, count, flags)


def unpack_header(data):
    """Returns (type, cpi_id, pri_idx, seg, count, flags) or raises ValueError."""
    if len(data) < HEADER.size:
        raise ValueError('packet shorter than the header')
    magic, version, ptype, cpi_id, pri_idx, seg, count, flags = HEADER.unpack_from(data)
    if magic != MAGIC or version != VERSION:
        raise ValueError('bad magic or version')
    return ptype, cpi_id, pri_idx, seg, count, flags


def _samples(iq):
    """iq: list of (i, q) integers -> interleaved int16 bytes."""
    flat = [v for pair in iq for v in pair]
    return struct.pack('<%dh' % len(flat), *flat)


def _iq(data, count):
    flat = struct.unpack_from('<%dh' % (2 * count), data, HEADER.size)
    return [(flat[2 * n], flat[2 * n + 1]) for n in range(count)]


def pack_config(tx_iq, params):
    """tx_iq: N_PULSE_SAMPLE (i, q) pairs in Q2.14. params: dict of the CONFIG_PARAMS fields."""
    p = CONFIG_PARAMS.pack(params['n_pri'], params['n_pulse'], params['n_pulse_sample'], params['nfft'],
                           params['num_ref'], params['num_guard'], params['k'], params['threshold_factor'],
                           params['max_gap'], params['peak_ratio_q8'])
    return _header(T_CONFIG, 0, 0, 0, len(tx_iq), 0) + _samples(tx_iq) + p


def unpack_config(data):
    _, _, _, _, count, _ = unpack_header(data)
    tx_iq = _iq(data, count)
    v = CONFIG_PARAMS.unpack_from(data, HEADER.size + 4 * count)
    keys = ('n_pri', 'n_pulse', 'n_pulse_sample', 'nfft', 'num_ref', 'num_guard', 'k',
            'threshold_factor', 'max_gap', 'peak_ratio_q8')
    return tx_iq, dict(zip(keys, v))


def pack_rx(cpi_id, pri_idx, seg, iq):
    """One RX packet. iq: SAMPLES_PER_PACKET (i, q) pairs, seg: 0..PACKETS_PER_PRI-1."""
    flags = 0
    if pri_idx == 0 and seg == 0:
        flags |= F_FIRST
    if pri_idx == N_PULSE - 1 and seg == PACKETS_PER_PRI - 1:
        flags |= F_LAST
    return _header(T_RX, cpi_id, pri_idx, seg, len(iq), flags) + _samples(iq)


def unpack_rx(data):
    """Returns (cpi_id, pri_idx, seg, flags, iq)."""
    _, cpi_id, pri_idx, seg, count, flags = unpack_header(data)
    return cpi_id, pri_idx, seg, flags, _iq(data, count)


def pack_result(cpi_id, detected_idx0, latency_cycles=0, flags=0):
    """detected_idx0: 0 based range cells (ascending). Words beyond MAXDET are cut, overflow is set."""
    n = len(detected_idx0)
    idx = list(detected_idx0[:MAXDET]) + [0] * (MAXDET - min(n, MAXDET))
    body = RESULT_BODY.pack(min(n, MAXDET), int(n > MAXDET), *idx, latency_cycles)
    return _header(T_RESULT, cpi_id, 0, 0, min(n, MAXDET), flags) + body


def unpack_result(data):
    """Returns dict: cpi_id, flags, count, overflow, idx0 (list), latency_cycles."""
    _, cpi_id, _, _, _, flags = unpack_header(data)
    v = RESULT_BODY.unpack_from(data, HEADER.size)
    return {'cpi_id': cpi_id, 'flags': flags, 'count': v[0], 'overflow': v[1],
            'idx0': list(v[2:2 + v[0]]), 'latency_cycles': v[2 + MAXDET]}
