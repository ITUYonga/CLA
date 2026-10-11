"""Loopback test of the link (no board): python test_loopback.py <vector_dir>

Runs mock_board and the sender on this PC over UDP (127.0.0.1) and checks:
  1. normal CPIs: the samples reach the board unchanged and the RESULT is the expected one
  2. one lost packet: the RESULT is marked INCOMPLETE, the other CPIs are not affected
  3. packets sent in random order: the CPI is still complete
"""
import socket
import sys
import threading

import mock_board
import radar_link as L
import send_cpi
import vectors_io as V


def scenario(vec_dir, port, n, **kw):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(('127.0.0.1', port))
    stop = threading.Event()
    exp = V.load_manifest(vec_dir)['expected']['detected_idx0']
    out = {}

    def target():
        out['answered'], out['config'] = mock_board.serve(sock, port + 1, exp, stop, V.load_rx(vec_dir))

    th = threading.Thread(target=target)
    th.start()
    res, starts, err = send_cpi.run(vec_dir, '127.0.0.1', port, port + 1, n, **kw)
    stop.set()
    th.join()
    sock.close()
    return res, err, out, exp


def main(vec_dir):
    # 1. normal
    res, err, out, exp = scenario(vec_dir, 25005, 5)
    assert len(res) == 5, 'missing results %s' % sorted(res)
    for cid, r in res.items():
        assert r['flags'] == 0 and r['idx0'] == exp, (cid, r)
    tx, prm = out['config']
    assert tx == V.load_tx(vec_dir) and prm == V.config_from_manifest(V.load_manifest(vec_dir)), 'CONFIG mismatch'
    print('1. normal      : 5/5 CPIs correct, idx0 %s, CONFIG received, send start error max %.2f ms'
          % (exp, 1e3 * max(abs(e) for e in err)))

    # 2. one lost packet in cpi 2
    res, err, out, exp = scenario(vec_dir, 25007, 4, drop_at=2)
    assert res[2]['flags'] & L.F_INCOMPLETE and res[2]['idx0'] == [], res[2]
    assert all(res[c]['flags'] == 0 and res[c]['idx0'] == exp for c in (0, 1, 3)), res
    print('2. lost packet : cpi 2 INCOMPLETE, cpi 0, 1, 3 correct')

    # 3. random packet order
    res, err, out, exp = scenario(vec_dir, 25009, 3, shuffle=True)
    assert all(res[c]['flags'] == 0 and res[c]['idx0'] == exp for c in range(3)), res
    print('3. shuffled    : 3/3 CPIs complete and correct')
    print('OK')


if len(sys.argv) != 2:
    raise SystemExit(__doc__)
main(sys.argv[1])
