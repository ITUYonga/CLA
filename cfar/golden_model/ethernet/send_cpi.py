"""send_cpi.py : PC side. Sends the TX pulse and the CPIs of a test vector to the board.

Purpose:  Reads a vector folder (func_export_vectors.m output), sends CONFIG once and
          then one CPI every 20 ms (80 packets in a burst), receives the RESULTs.

Usage:    python send_cpi.py <vector_dir> [--host 192.168.1.10] [--port 5005] [--result-port 5006] [--cpis 3]
"""
import argparse
import random
import socket
import time

import radar_link as L
import vectors_io as V

CPI_PERIOD_S = 0.020


def send_config(sock, addr, vec_dir):
    m = V.load_manifest(vec_dir)
    sock.sendto(L.pack_config(V.load_tx(vec_dir), V.config_from_manifest(m)), addr)


def send_cpi(sock, addr, cpi_id, rx_pulses, drop=(), shuffle=False):
    """Sends the 80 packets of one CPI. drop: set of (pri, seg) that are not sent (loss test)."""
    packets = []
    for pri in range(L.N_PULSE):
        for seg in range(L.PACKETS_PER_PRI):
            if (pri, seg) in drop:
                continue
            iq = rx_pulses[pri][seg * L.SAMPLES_PER_PACKET:(seg + 1) * L.SAMPLES_PER_PACKET]
            packets.append(L.pack_rx(cpi_id, pri, seg, iq))
    if shuffle:
        random.shuffle(packets)
    for pk in packets:
        sock.sendto(pk, addr)
    return len(packets)


def run(vec_dir, host, port, result_port, n_cpis, drop_at=None, shuffle=False):
    """Sends n_cpis CPIs on a 20 ms grid. Returns (results by cpi_id, start times, start errors vs the grid)."""
    rx = V.load_rx(vec_dir)
    tx = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    rcv = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    rcv.bind(('', result_port))
    rcv.settimeout(0.5)

    send_config(tx, (host, port), vec_dir)
    time.sleep(0.01)
    results, starts = {}, []
    t0 = time.perf_counter()
    for cpi_id in range(n_cpis):
        target = t0 + cpi_id * CPI_PERIOD_S
        while time.perf_counter() < target:                  # wait for the 20 ms grid
            pass
        starts.append(time.perf_counter() - t0)
        drop = {(3, 1)} if drop_at == cpi_id else ()
        send_cpi(tx, (host, port), cpi_id, rx, drop, shuffle)
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
    return results, starts, errors


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('vec_dir')
    ap.add_argument('--host', default='127.0.0.1')
    ap.add_argument('--port', type=int, default=5005)
    ap.add_argument('--result-port', type=int, default=5006)
    ap.add_argument('--cpis', type=int, default=3)
    a = ap.parse_args()
    res, starts, err = run(a.vec_dir, a.host, a.port, a.result_port, a.cpis)
    exp = V.load_manifest(a.vec_dir)['expected']['detected_idx0']
    for cid in range(a.cpis):
        r = res.get(cid)
        if r is None:
            print('cpi %d: NO RESULT' % cid)
        else:
            print('cpi %d: idx0 %s (expected %s)%s' % (cid, r['idx0'], exp,
                  ' INCOMPLETE' if r['flags'] & L.F_INCOMPLETE else ''))
    print('send start error vs the 20 ms grid: max %.2f ms' % (1e3 * max(abs(e) for e in err)))
