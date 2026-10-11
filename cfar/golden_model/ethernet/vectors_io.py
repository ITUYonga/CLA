"""vectors_io.py : Reads the test vector folder written by func_export_vectors.m

Purpose:  Gives the sender the TX pulse and the received signal (16 bit I/Q) and
          gives the tests the expected detections.
"""
import json
import os

import radar_link as L


def read_mem(path, width):
    """$readmemh style file (one two's complement hex word per line) -> list of signed ints."""
    out = []
    with open(path) as f:
        for line in f:
            line = line.strip()
            if line:
                v = int(line, 16)
                out.append(v - (1 << width) if v >= (1 << (width - 1)) else v)
    return out


def load_tx(vec_dir):
    """20 (I, Q) pairs of the windowed TX pulse in Q2.14."""
    re = read_mem(os.path.join(vec_dir, 't0_tx_pulse_win_re.mem'), 16)
    im = read_mem(os.path.join(vec_dir, 't0_tx_pulse_win_im.mem'), 16)
    return list(zip(re, im))


def load_rx(vec_dir):
    """N_PULSE lists of N_PRI (I, Q) pairs. The file order is pulse-major, so one PRI is one slice."""
    re = read_mem(os.path.join(vec_dir, 't1_rx_re.mem'), 16)
    im = read_mem(os.path.join(vec_dir, 't1_rx_im.mem'), 16)
    iq = list(zip(re, im))
    assert len(iq) == L.N_PRI * L.N_PULSE, 'unexpected rx size %d' % len(iq)
    return [iq[p * L.N_PRI:(p + 1) * L.N_PRI] for p in range(L.N_PULSE)]


def load_manifest(vec_dir):
    with open(os.path.join(vec_dir, 'manifest.json')) as f:
        return json.load(f)


def config_from_manifest(m):
    p = m['parameters']
    return dict(n_pri=int(p['N_PRI']), n_pulse=int(p['N_Pulse']), n_pulse_sample=L.N_PULSE_SAMPLE,
                nfft=int(p['NFFT']), num_ref=int(p['num_ref']), num_guard=int(p['num_guard']),
                k=int(p['k']), threshold_factor=int(p['threshold_factor']), max_gap=int(p['max_gap']),
                peak_ratio_q8=int(round(p['peak_ratio'] * 256)))
