"""mock_board.py : Stands in for the KV260 PS side to test the link without the board.

Purpose:  Receives CONFIG and RX packets, checks that all 80 packets of a CPI arrived
          (in any order) and answers with a RESULT. It does no radar processing, the
          detections it returns are the expected ones of the vector (the real board
          returns the PL result).
"""
import socket
import time

import radar_link as L

GRACE_S = 0.005          # a CPI is 'incomplete' if its last packet (F_LAST) has arrived and no packet came for this long


def serve(sock, result_port, expected_idx0, stop, reference_rx=None):
    """Runs until stop.is_set(). Returns (answered cpi_ids, last CONFIG as (tx_iq, params))."""
    sock.settimeout(0.002)
    cpis = {}            # cpi_id -> {'pk': {(pri, seg): iq}, 'seen_last': bool, 't_recv': time of the latest packet, 'ip': ip}
    answered = []
    config = None

    def answer(cpi_id, src_ip, ok):
        r = L.pack_result(cpi_id, expected_idx0 if ok else [], 0, 0 if ok else L.F_INCOMPLETE)
        sock.sendto(r, (src_ip, result_port))
        answered.append(cpi_id)
        cpis.pop(cpi_id, None)

    while not stop.is_set():
        try:
            data, (src_ip, _) = sock.recvfrom(2048)
            ptype = L.unpack_header(data)[0]
            if ptype == L.T_CONFIG:
                config = L.unpack_config(data)
            elif ptype == L.T_RX:
                cpi_id, pri, seg, flags, iq = L.unpack_rx(data)
                c = cpis.setdefault(cpi_id, {'pk': {}, 'seen_last': False, 't_recv': 0.0, 'ip': src_ip})
                c['pk'][(pri, seg)] = iq
                c['t_recv'] = time.perf_counter()
                if flags & L.F_LAST:
                    c['seen_last'] = True
        except (socket.timeout, ValueError, ConnectionResetError):
            pass
        for cpi_id, c in list(cpis.items()):
            if len(c['pk']) == L.PACKETS_PER_CPI:
                ok = True
                if reference_rx is not None:          # optional: the samples must be the ones of the vector
                    for p in range(L.N_PULSE):
                        row = [s for g in range(L.PACKETS_PER_PRI) for s in c['pk'][(p, g)]]
                        ok = ok and row == reference_rx[p]
                answer(cpi_id, c['ip'], ok)
            elif c['seen_last'] and time.perf_counter() - c['t_recv'] > GRACE_S:
                answer(cpi_id, c['ip'], False)
    return answered, config
