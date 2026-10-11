"""send_flight_cpi.py : PC side, ALTERNATIVE to send_cpi.py for the flight (many-CPI) vector set.

Purpose:  send_cpi.py reads ONE rx (a single-frame vector, func_export_vectors.m's output) and
          replays that SAME CPI --cpis times. This script is for
          func_export_flight_vectors.m's output instead: a long run where every CPI has its OWN
          rx and its OWN expected detection, read from cpi_0000/, cpi_0001/, ... subfolders
          (see docs/UCUS_VEKTOR_URETIMI.md). It is a separate script on purpose, so send_cpi.py
          (and the single-frame flow it was built and tested for) stays untouched. It reuses
          send_cpi.py's send_cpi() and vectors_io.py's read_mem()/load_tx()/load_manifest() as
          they are.

          Spec: docs/ETHERNET_PROTOKOLU.md (packet format, same for both scripts).

Usage:    python send_flight_cpi.py <flight_vec_dir> [--host 192.168.1.10] [--port 5005]
                                     [--result-port 5006] [--cpis N] [--start 0]
          <flight_vec_dir> : e.g. vectors/vec_flight_40s_nfft128 (func_export_flight_vectors.m output)
          --cpis            : how many CPIs to send, default: all of them (can be slow for a long set)
          --start           : first CPI to send (0 based), for sending a slice of a long set
"""
import argparse
import os
import socket
import time

import radar_link as L
import vectors_io as V
from send_cpi import send_cpi   # reused as-is: packs and sends the 80 packets of one CPI

CPI_PERIOD_S = 0.020


def load_rx_cpi(cpi_dir):
    """Same shape as vectors_io.load_rx (N_PULSE lists of N_PRI (I, Q) pairs), but reads a
    single cpi_XXXX folder, which only has t1_rx_re.mem / t1_rx_im.mem (no t0, no t2-t7)."""
    re = V.read_mem(os.path.join(cpi_dir, 't1_rx_re.mem'), 16)
    im = V.read_mem(os.path.join(cpi_dir, 't1_rx_im.mem'), 16)
    iq = list(zip(re, im))
    assert len(iq) == L.N_PRI * L.N_PULSE, 'unexpected rx size %d in %s' % (len(iq), cpi_dir)
    return [iq[p * L.N_PRI:(p + 1) * L.N_PRI] for p in range(L.N_PULSE)]


def config_from_flight_manifest(m):
    """func_export_flight_vectors.m's manifest has radar_cfg / cfar_cfg structs (not the
    single-frame manifest's flat 'parameters' dict), so vectors_io.config_from_manifest does
    not fit it -- this is the flight equivalent, same output shape (CONFIG_PARAMS fields)."""
    r, c = m['radar_cfg'], m['cfar_cfg']
    return dict(n_pri=int(round(r['fs'] * r['PRI'])), n_pulse=int(r['N_Pulse']), n_pulse_sample=L.N_PULSE_SAMPLE,
                nfft=int(r['NFFT']), num_ref=int(c['num_ref']), num_guard=int(c['num_guard']),
                k=int(c['k']), threshold_factor=int(c['threshold_factor']), max_gap=int(c['max_gap']),
                peak_ratio_q8=int(round(c['peak_ratio'] * 256)))


def run(vec_dir, host, port, result_port, n_cpis=None, start=0):
    """Sends CPIs [start, start + n_cpis) of the set on a 20 ms grid, each with its own rx.
    n_cpis=None sends every CPI the set has (from manifest.json's n_cpi).
    Returns (results by cpi_id, expected idx0 by cpi_id, start times, start errors vs the grid)."""
    m = V.load_manifest(vec_dir)
    total = m['n_cpi']
    if n_cpis is None:
        n_cpis = total - start
    assert start >= 0 and start + n_cpis <= total, 'set only has %d CPIs (cpi_0000 .. cpi_%04d)' % (total, total - 1)

    tx = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    rcv = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    rcv.bind(('', result_port))
    rcv.settimeout(0.5)

    tx.sendto(L.pack_config(V.load_tx(vec_dir), config_from_flight_manifest(m)), (host, port))
    time.sleep(0.01)

    # Prefetch CPI 0's rx BEFORE starting the clock, so its disk read does not eat into the
    # 20 ms grid (each CPI is its own file here, unlike send_cpi.py which loads rx once and
    # reuses it, so this script would otherwise add read latency to every 'target' below).
    rx_next = load_rx_cpi(os.path.join(vec_dir, 'cpi_%04d' % start))

    results, expected, starts = {}, {}, []
    t0 = time.perf_counter()
    for n in range(n_cpis):
        cpi_id = start + n
        rx = rx_next
        expected[cpi_id] = m['per_cpi']['detected_idx0'][cpi_id]

        target = t0 + n * CPI_PERIOD_S
        while time.perf_counter() < target:            # wait for the 20 ms grid, same as send_cpi.py
            pass
        starts.append(time.perf_counter() - t0)
        send_cpi(tx, (host, port), cpi_id, rx)

        if n + 1 < n_cpis:                              # prefetch the NEXT CPI while this one's grid slot is still running
            rx_next = load_rx_cpi(os.path.join(vec_dir, 'cpi_%04d' % (cpi_id + 1)))

    deadline = time.perf_counter() + 1.0
    while len(results) < n_cpis and time.perf_counter() < deadline:
        try:
            data, _ = rcv.recvfrom(2048)
            r = L.unpack_result(data)
            results[r['cpi_id']] = r
        except socket.timeout:
            pass
    tx.close()
    rcv.close()
    errors = [s - i * CPI_PERIOD_S for i, s in enumerate(starts)]
    return results, expected, starts, errors


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('vec_dir')
    ap.add_argument('--host', default='127.0.0.1')
    ap.add_argument('--port', type=int, default=5005)
    ap.add_argument('--result-port', type=int, default=5006)
    ap.add_argument('--cpis', type=int, default=None, help='number of CPIs to send, default: all of them')
    ap.add_argument('--start', type=int, default=0, help='first CPI (0 based) to send')
    a = ap.parse_args()

    res, exp, starts, err = run(a.vec_dir, a.host, a.port, a.result_port, a.cpis, a.start)

    n_ok = n_bad = n_missing = 0
    for cpi_id in sorted(exp):
        r = res.get(cpi_id)
        if r is None:
            n_missing += 1
            print('cpi %d: NO RESULT' % cpi_id)
        elif r['idx0'] == exp[cpi_id]:
            n_ok += 1
        else:
            n_bad += 1
            print('cpi %d: idx0 %s (expected %s)%s' % (cpi_id, r['idx0'], exp[cpi_id],
                  ' INCOMPLETE' if r['flags'] & L.F_INCOMPLETE else ''))

    print('%d / %d CPIs matched the expected detection (%d mismatched, %d missing)' %
          (n_ok, len(exp), n_bad, n_missing))
    if err:
        print('send start error vs the 20 ms grid: max %.2f ms' % (1e3 * max(abs(e) for e in err)))
