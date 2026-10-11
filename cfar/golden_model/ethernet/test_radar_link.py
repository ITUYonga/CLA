"""Unit test of the packet format (no network needed): python test_radar_link.py"""
import radar_link as L

def main():
    # sizes
    rx = L.pack_rx(7, 3, 2, [(1, -2)] * L.SAMPLES_PER_PACKET)
    assert len(rx) == 16 + 4 * 250 == 1016, len(rx)
    assert len(rx) + 28 <= 1500                              # + IP and UDP header fits the MTU

    # rx round trip, flags
    iq = [(n - 100, 100 - n) for n in range(250)]
    cpi, pri, seg, flags, out = L.unpack_rx(L.pack_rx(9, 0, 0, iq))
    assert (cpi, pri, seg, flags, out) == (9, 0, 0, L.F_FIRST, iq)
    assert L.unpack_rx(L.pack_rx(9, 19, 3, iq))[3] == L.F_LAST
    assert L.unpack_rx(L.pack_rx(9, 5, 1, iq))[3] == 0
    lo = [(-32768, 32767)] * 250                              # 16 bit limits
    assert L.unpack_rx(L.pack_rx(1, 1, 1, lo))[4] == lo

    # config round trip
    tx = [(16384, 0)] * 20
    prm = dict(n_pri=1000, n_pulse=20, n_pulse_sample=20, nfft=128, num_ref=30, num_guard=6,
               k=20, threshold_factor=8, max_gap=15, peak_ratio_q8=128)
    assert L.unpack_config(L.pack_config(tx, prm)) == (tx, prm)

    # result round trip, overflow
    r = L.unpack_result(L.pack_result(4, [564], 1234))
    assert r == {'cpi_id': 4, 'flags': 0, 'count': 1, 'overflow': 0, 'idx0': [564], 'latency_cycles': 1234}, r
    r = L.unpack_result(L.pack_result(5, list(range(20)), 0, L.F_INCOMPLETE))
    assert r['count'] == 16 and r['overflow'] == 1 and r['flags'] == L.F_INCOMPLETE and r['idx0'] == list(range(16))
    assert L.unpack_result(L.pack_result(6, []))['idx0'] == []

    # bad packets are rejected
    for bad in (b'', b'\x00' * 16, L.pack_rx(1, 0, 0, iq)[:8]):
        try:
            L.unpack_header(bad); raise SystemExit('accepted a bad packet')
        except ValueError:
            pass
    print('OK: packet format tests passed (rx packet %d bytes, %d packets per CPI)' % (len(rx), L.PACKETS_PER_CPI))

main()
