#!/usr/bin/env python3
import argparse
import json
import math
import os
import queue
import socket
import struct
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

import numpy as np

C0 = 3e8
FS = 1e6
DR = C0 / (2 * FS)
PRF = 1000.0
LAMBDA = 0.1
NP = 20
NR = 1000
NFFT = 128
T_CPI = NP / PRF
NOISE_SIGMA = 373.0
R_REF = 50e3
M_PER_NM = 1852.0
MAXDET = 16

TX_RE = [0x0051, 0x015e, 0x03c3, 0x0743, 0x0895, 0x0000, 0xe7fb, 0xced0, 0xda94, 0x178f,
         0x4000, 0x0e99, 0xd22d, 0xf221, 0x1934, 0x0000, 0xf801, 0x02fe, 0x0016, 0xffc2]
TX_IM = [0x0000, 0x0016, 0x00f7, 0x049c, 0x0d86, 0x1a05, 0x1d08, 0x0318, 0xd2c4, 0xc47f,
         0x0000, 0x38dd, 0x1224, 0xdcf7, 0xf987, 0x1004, 0xfcd5, 0xfd86, 0x015e, 0xffcd]


def s16(v):
    return v - 65536 if v >= 32768 else v


TX_I = np.array([s16(v) for v in TX_RE], dtype=np.int64)
TX_Q = np.array([s16(v) for v in TX_IM], dtype=np.int64)
TX = (TX_I + 1j * TX_Q) / 16384.0
TX_WORDS = [((int(q) & 0xFFFF) << 16) | (int(i) & 0xFFFF) for i, q in zip(TX_I, TX_Q)]
WIN = np.array([380, 1777, 5200, 11632, 21495, 34114, 47543, 58954, 65536,
                65536, 58954, 47543, 34114, 21495, 11632, 5200, 1777, 380]) / 65536.0

MAGIC = 0x5244
HDR = struct.Struct('<HBBHHI')

WGS_A = 6378137.0
WGS_E2 = 6.69437999014e-3

HEX = np.full(256, 255, dtype=np.uint8)
for _k, _c in enumerate(b'0123456789abcdef'):
    HEX[_c] = _k
for _k, _c in enumerate(b'ABCDEF'):
    HEX[_c] = 10 + _k


def read_mem(path):
    with open(path, 'rb') as f:
        b = f.read().replace(b'\r', b'')
    if not b.endswith(b'\n'):
        b += b'\n'
    a = np.frombuffer(b, dtype=np.uint8)
    if a.size % 5 == 0 and np.all(a[4::5] == 10):
        d = HEX[a.reshape(-1, 5)[:, :4]].astype(np.uint32)
        if not np.any(d == 255):
            return (d[:, 0] << 12) | (d[:, 1] << 8) | (d[:, 2] << 4) | d[:, 3]
    return np.array([int(x, 16) for x in b.split()], dtype=np.uint32)


def lla2ecef(lla):
    lat, lon, h = np.radians(lla[..., 0]), np.radians(lla[..., 1]), lla[..., 2]
    n = WGS_A / np.sqrt(1 - WGS_E2 * np.sin(lat) ** 2)
    return np.stack([(n + h) * np.cos(lat) * np.cos(lon), (n + h) * np.cos(lat) * np.sin(lon),
                     (n * (1 - WGS_E2) + h) * np.sin(lat)], axis=-1)


def lla2ned(lla, lla0):
    lat, lon = math.radians(lla0[0]), math.radians(lla0[1])
    rot = np.array([[-math.sin(lat) * math.cos(lon), -math.sin(lat) * math.sin(lon), math.cos(lat)],
                    [-math.sin(lon), math.cos(lon), 0.0],
                    [-math.cos(lat) * math.cos(lon), -math.cos(lat) * math.sin(lon), -math.sin(lat)]])
    return (lla2ecef(np.asarray(lla, float)) - lla2ecef(np.asarray(lla0, float))) @ rot.T


def mti_db(vr):
    th = 2 * math.pi * (2 * vr / LAMBDA) / PRF
    return 10 * math.log10(max(16 * math.sin(th / 2) ** 4 / 6, 1e-6))


class ScenarioSource:
    def __init__(self, vec_dir):
        self.dir = vec_dir
        with open(os.path.join(vec_dir, 'manifest.json'), encoding='utf-8') as f:
            m = json.load(f)
        self.name = m.get('name', os.path.basename(os.path.normpath(vec_dir)))
        self.n = int(m['n_cpi'])
        pc = m['per_cpi']
        self.t = np.asarray(pc['t'], float).reshape(-1)
        self.az = np.asarray(pc['beam_az'], float).reshape(-1)
        self.el = -np.asarray(pc['beam_el'], float).reshape(-1)
        self.bar = np.asarray(pc['bar_idx'], int).reshape(-1)
        sc, cc, scn = m['scan_cfg'], m['cfar_cfg'], m['scenario']
        self.cfg = {'k': int(cc['k']), 'tf': float(cc['threshold_factor']),
                    'gap': int(cc['max_gap']), 'ratio': float(cc['peak_ratio'])}
        nb, step = int(sc['n_bars']), float(sc['el_step'])
        self.scan = {'az_center': float(sc['az_center']), 'az_span': float(sc['az_width']),
                     'rate': float(sc['az_rate_dps']),
                     'el_center': -(float(sc['el_top']) + (nb - 1) / 2 * step), 'bars': nb,
                     'bar_step': step, 'beamwidth': float(scn['hpbw_az'])}
        self.hpbw = (float(scn['hpbw_az']), float(scn['hpbw_el']))
        self.floor_db = float(scn.get('floor_dB', -50))
        lla0 = np.asarray(scn['ac_lla0'], float).reshape(3)
        self.ac_vel = np.asarray(scn['ac_vel_ned'], float).reshape(3)
        tl = np.asarray(scn['tgt_lla'], float).reshape(-1, 3)
        self.tgt_ned0 = lla2ned(tl, lla0)
        self.tgt_alt = tl[:, 2]
        self.tgt_vel = np.asarray(scn['tgt_vel_ned'], float).reshape(-1, 3)
        self.words = np.empty((self.n, NP * NR), np.uint32)
        self.exp = np.zeros((self.n, MAXDET + 1), np.int32)
        self.loaded = 0
        self.i = 0

    def load(self, progress):
        global TX, TX_WORDS
        tx = []
        for part in ('re', 'im'):
            v = read_mem(os.path.join(self.dir, 't0_tx_pulse_win_%s.mem' % part)).astype(np.int64)
            v[v >= 32768] -= 65536
            tx.append(v)
        if tx[0].size != 20 or tx[1].size != 20:
            raise ValueError('t0 boyutu hatali')
        TX = (tx[0] + 1j * tx[1]) / 16384.0
        TX_WORDS = [((int(q) & 0xFFFF) << 16) | (int(i) & 0xFFFF) for i, q in zip(tx[0], tx[1])]

        cdir = os.path.join(self.dir, '_gui_cache')
        wf, ef = os.path.join(cdir, 'words.npy'), os.path.join(cdir, 'exp.npy')
        if os.path.exists(wf) and os.path.exists(ef):
            w, e = np.load(wf, mmap_mode='r'), np.load(ef)
            if w.shape == self.words.shape and e.shape == self.exp.shape:
                self.words, self.exp, self.loaded = w, e, self.n
                return
        for i in range(self.n):
            d = os.path.join(self.dir, 'cpi_%04d' % i)
            re = read_mem(os.path.join(d, 't1_rx_re.mem'))
            im = read_mem(os.path.join(d, 't1_rx_im.mem'))
            if re.size != NP * NR or im.size != NP * NR:
                raise ValueError('%s: t1 boyutu %d, beklenen %d' % (d, re.size, NP * NR))
            self.words[i] = (im << 16) | re
            x = read_mem(os.path.join(d, 't7_detected.mem'))
            c = min(int(x[0]), MAXDET)
            self.exp[i, 0] = c
            self.exp[i, 1:1 + c] = x[1:1 + c]
            self.loaded = i + 1
            if i % 50 == 0 or i == self.n - 1:
                progress(i + 1, self.n)
        try:
            os.makedirs(cdir, exist_ok=True)
            np.save(wf, self.words)
            np.save(ef, self.exp)
        except OSError:
            pass

    def truth(self, t, beam_az, beam_el):
        rel = self.tgt_ned0 + (self.tgt_vel - self.ac_vel) * t
        relv = self.tgt_vel - self.ac_vel
        out = []
        for k in range(len(rel)):
            n, e, d = rel[k]
            r = float(np.linalg.norm(rel[k]))
            az = math.degrees(math.atan2(e, n)) % 360
            el = math.degrees(math.atan2(-d, math.hypot(n, e)))
            vr = float(np.dot(rel[k], relv[k]) / r)
            daz = ((az - beam_az + 180) % 360 - 180) * math.cos(math.radians(beam_el))
            d2 = (daz / self.hpbw[0]) ** 2 + ((el - beam_el) / self.hpbw[1]) ** 2
            beam_db = max(-10 * math.log10(math.e) * 4 * math.log(2) * d2, self.floor_db)
            vn, ve, vd = self.tgt_vel[k]
            md = mti_db(vr)
            out.append({'id': k + 1, 'enabled': True, 'range_km': round(r / 1e3, 2), 'az': round(az, 2),
                        'el': round(el, 2), 'speed': round(math.hypot(vn, ve), 1),
                        'heading': round(math.degrees(math.atan2(ve, vn)) % 360, 1), 'climb': round(-vd, 1),
                        'snr_db': None, 'beam_db': round(beam_db, 1), 'cell': int(round(r / DR)),
                        'vr': round(vr, 1), 'v_alias': round(((vr + 25) % 50) - 25, 1),
                        'mti_db': round(md, 1), 'blind': md < -6,
                        'alt_m': round(float(self.tgt_alt[k] - vd * t))})
        return out


class BoardLink:
    name = 'KART'

    def __init__(self, host, port):
        self.host, self.port = host, port
        self.sock = None

    def _recv_all(self, n):
        buf = bytearray()
        while len(buf) < n:
            chunk = self.sock.recv(n - len(buf))
            if not chunk:
                raise ConnectionError('baglanti kapandi')
            buf += chunk
        return bytes(buf)

    def _xfer(self, typ, cpi, payload, reply):
        self.sock.sendall(HDR.pack(MAGIC, typ, 0, cpi & 0xFFFF, 0, len(payload)) + payload)
        while True:
            m, t, _, c, _, ln = HDR.unpack(self._recv_all(HDR.size))
            body = self._recv_all(ln) if ln else b''
            if m != MAGIC:
                raise ConnectionError('gecersiz cevap')
            if t == reply:
                return body

    def connect(self):
        self.close()
        s = socket.create_connection((self.host, self.port), timeout=3)
        s.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        self.sock = s
        self._xfer(0x03, 0, b'', 0x83)

    def close(self):
        if self.sock:
            try:
                self.sock.close()
            except OSError:
                pass
        self.sock = None

    def config(self, k, tf, gap, ratio):
        alpha = int(round(math.log2(tf) * 1024))
        lr = int(round(math.log2(ratio) * 1024))
        body = struct.pack('<IiiI', k, alpha, lr, gap) + struct.pack('<20I', *TX_WORDS)
        a = struct.unpack('<IIiiI', self._xfer(0x01, 0, body, 0x81))
        if a[0] != 0:
            raise RuntimeError('CONFIG reddedildi status=%d' % a[0])

    def run(self, words, cpi):
        w = struct.unpack('<22I', self._xfer(0x02, cpi, words.tobytes(), 0x82))
        return {'status': w[0], 'idx': list(w[6:6 + min(w[1], MAXDET)]), 'ovf': w[2],
                'lat_clk': w[3]}


class ModelLink:
    name = 'MODEL'

    def __init__(self):
        self.k, self.tf, self.gap, self.ratio = 20, 8.0, 15, 0.5

    def connect(self):
        pass

    def close(self):
        pass

    def config(self, k, tf, gap, ratio):
        self.k, self.tf, self.gap, self.ratio = k, tf, gap, ratio

    def run(self, words, cpi):
        return {'status': 0, 'idx': model_detect(words, self.k, self.tf, self.gap, self.ratio),
                'ovf': 0, 'lat_clk': 0}


def model_detect(words, k, tf, gap, ratio, ref=30, guard=6):
    w = words.view(np.uint32).reshape(NP, NR)
    i = (w & 0xFFFF).astype(np.int32)
    q = (w >> 16).astype(np.int32)
    i[i >= 32768] -= 65536
    q[q >= 32768] -= 65536
    rx = i + 1j * q
    h = np.conj(TX[::-1])
    mf = np.array([np.convolve(rx[p], h)[10:10 + NR] for p in range(NP)])
    mti = mf[:-2] - 2 * mf[1:-1] + mf[2:]
    sp = np.fft.fftshift(np.fft.fft(mti * WIN[:, None], NFFT, axis=0), axes=0)
    pw = np.abs(sp.T) ** 2
    half, g = ref // 2, guard // 2
    offs = np.r_[np.arange(-g - half, -g), np.arange(g + 1, g + half + 1)]
    rows = np.arange(NR)[:, None] + offs[None, :]
    valid = (rows >= 0) & (rows < NR)
    refv = np.where(valid[:, :, None], pw[np.clip(rows, 0, NR - 1)], np.inf)
    refv.sort(axis=1)
    kk = np.minimum(k, valid.sum(axis=1)) - 1
    kth = np.take_along_axis(refv, kk[:, None, None].repeat(NFFT, 2), axis=1)[:, 0, :]
    thr = kth * tf
    pmax, tmax = pw.max(axis=1), thr.max(axis=1)
    cross = pmax > tmax
    cand, r = [], 0
    while r < NR:
        if cross[r]:
            e = r
            while e < NR and cross[e]:
                e += 1
            cand.append(r + int(np.argmax(pmax[r:e])))
            r = e
        else:
            r += 1
    det = []
    for c in cand:
        if det and (c - det[-1]) < gap and not (ratio <= pmax[c] / pmax[det[-1]] <= 1 / ratio):
            if pmax[c] > pmax[det[-1]]:
                det[-1] = c
        else:
            det.append(c)
    return det[:MAXDET]


class Scene:
    def __init__(self):
        self.lock = threading.Lock()
        self.radar = {'k': 20, 'tf': 12.0, 'gap': 15, 'ratio': 0.5}
        self.scan = {'az_center': 53.51, 'az_span': 60.0, 'rate': 60.0, 'el_center': 0.0,
                     'bars': 4, 'bar_step': 3.0, 'beamwidth': 3.0}
        self.noise_sigma = NOISE_SIGMA
        self.frozen = False
        self.next_id = 1
        self.targets = []
        self.reset_targets()
        self.radar_dirty = True
        self.beam_az = self.scan['az_center'] - self.scan['az_span'] / 2
        self.bar = 0
        self.dir = 1
        self.src = None
        self.speed = 1.0
        self.cur = (0.0, 0.0, 0.0)
        self.reset_stats()

    def use_scenario(self, src):
        self.src = src
        self.radar = dict(src.cfg)
        self.scan = dict(src.scan)
        self.targets = []
        self.cur = (float(src.t[0]), float(src.az[0]), float(src.el[0]))
        self.radar_dirty = True

    def reset_stats(self):
        self.stats = {'n': 0, 'exact': 0, 'near': 0, 'det_exp': 0, 'det_got': 0, 'bad_status': 0}

    def golden_cfg(self):
        if not self.src:
            return False
        a, b = self.radar, self.src.cfg
        return (int(a['k']) == b['k'] and int(a['gap']) == b['gap'] and abs(float(a['tf']) - b['tf']) < 1e-9
                and abs(float(a['ratio']) - b['ratio']) < 1e-9)

    def src_next(self):
        s = self.src
        if s.i >= s.n:
            s.i = 0
            self.reset_stats()
        if s.i >= s.loaded:
            return None
        i = s.i
        s.i += 1
        self.cur = (float(s.t[i]), float(s.az[i]), float(s.el[i]))
        exp = [int(v) for v in s.exp[i, 1:1 + s.exp[i, 0]]]
        return s.words[i], float(s.az[i]), float(s.el[i]), int(s.bar[i]), float(s.t[i]), exp, i

    def score(self, exp, got, status):
        st = self.stats
        st['n'] += 1
        st['det_exp'] += len(exp)
        st['det_got'] += len(got)
        st['bad_status'] += status != 0
        exact = exp == got
        near = len(exp) == len(got) and all(abs(a - b) <= 1 for a, b in zip(exp, got))
        st['exact'] += exact
        st['near'] += near
        return exact, near

    def reset_targets(self):
        self.targets = []
        for t in ({'range_km': 60, 'az': 45, 'el': 0, 'speed': 175, 'heading': 225, 'climb': 0, 'snr_db': 12},
                  {'range_km': 95, 'az': 68, 'el': 2, 'speed': 225, 'heading': 248, 'climb': 0, 'snr_db': 16},
                  {'range_km': 120, 'az': 33.5, 'el': -2.5, 'speed': 125, 'heading': 33.5, 'climb': 0, 'snr_db': 20}):
            self.add_target(t)

    def add_target(self, p):
        t = {'id': self.next_id, 'enabled': True}
        self.next_id += 1
        self._set_target(t, p)
        self.targets.append(t)
        return t['id']

    def _set_target(self, t, p):
        for key in ('range_km', 'az', 'el', 'speed', 'heading', 'climb', 'snr_db'):
            if key in p:
                t[key] = float(p[key])
        if 'enabled' in p:
            t['enabled'] = bool(p['enabled'])
        if any(k in p for k in ('range_km', 'az', 'el')):
            r = t['range_km'] * 1e3
            az, el = math.radians(t['az']), math.radians(t['el'])
            t['pos'] = np.array([r * math.cos(el) * math.sin(az), r * math.cos(el) * math.cos(az),
                                 r * math.sin(el)])
        h = math.radians(t['heading'])
        t['vel'] = np.array([t['speed'] * math.sin(h), t['speed'] * math.cos(h), t['climb']])

    @staticmethod
    def polar(t):
        x, y, z = t['pos']
        r = float(np.linalg.norm(t['pos']))
        az = math.degrees(math.atan2(x, y)) % 360
        el = math.degrees(math.asin(z / r)) if r > 0 else 0
        vr = float(np.dot(t['pos'], t['vel']) / r) if r > 0 else 0
        return r, az, el, vr

    def bar_el(self, b):
        s = self.scan
        return s['el_center'] + (s['bars'] - 1) / 2 * s['bar_step'] - b * s['bar_step']

    def step_beam(self):
        s = self.scan
        lo, hi = s['az_center'] - s['az_span'] / 2, s['az_center'] + s['az_span'] / 2
        self.beam_az += self.dir * s['rate'] * T_CPI
        if self.beam_az > hi or self.beam_az < lo:
            self.beam_az = min(max(self.beam_az, lo), hi)
            self.dir = -self.dir
            self.bar = (self.bar + 1) % max(1, int(s['bars']))
        if self.bar >= s['bars']:
            self.bar = 0

    def advance(self):
        for t in self.targets:
            t['pos'] = t['pos'] + t['vel'] * T_CPI

    def synth(self, rng):
        az0, el0 = self.beam_az, self.bar_el(self.bar)
        bw = self.scan['beamwidth']
        sig = self.noise_sigma
        rx = (rng.standard_normal((NP, NR)) + 1j * rng.standard_normal((NP, NR))) * sig
        pulses = np.arange(NP)
        lit = []
        for t in self.targets:
            if not t['enabled']:
                continue
            r, az, el, vr = self.polar(t)
            daz = ((az - az0 + 180) % 360 - 180) * math.cos(math.radians(el0))
            d2 = (daz ** 2 + (el - el0) ** 2) / bw ** 2
            gain_db = -10 * math.log10(math.e) * 4 * math.log(2) * d2
            if gain_db < -25:
                continue
            snr = t['snr_db'] + 40 * math.log10(R_REF / max(r, 1.0)) + gain_db
            amp = sig * math.sqrt(2) * 10 ** (snr / 20)
            cell = int(round(r / DR))
            start = cell - 9
            if start < 0 or start >= NR:
                continue
            n = min(20, NR - start)
            ph = 2 * math.pi * (2 * vr / LAMBDA) * pulses / PRF + rng.uniform(0, 2 * math.pi)
            rx[:, start:start + n] += amp * np.exp(1j * ph)[:, None] * TX[None, :n]
            lit.append(t['id'])
        i = np.clip(np.round(rx.real), -32768, 32767).astype(np.int32)
        q = np.clip(np.round(rx.imag), -32768, 32767).astype(np.int32)
        words = ((q & 0xFFFF).astype(np.uint32) << 16) | (i & 0xFFFF).astype(np.uint32)
        return words.reshape(-1), az0, el0, lit

    def snapshot(self):
        if self.src:
            s = self.src
            t, az, el = self.cur
            return {'mode': 'scenario', 'radar': dict(self.radar), 'scan': dict(self.scan),
                    'targets': s.truth(t, az, el), 'frozen': self.frozen, 'noise_sigma': self.noise_sigma,
                    'dr_m': DR, 'max_range_m': DR * NR, 't_cpi': T_CPI, 'speed': self.speed,
                    'sc': {'name': s.name, 'i': s.i, 'n': s.n, 'loaded': s.loaded, 't': round(t, 2),
                           'golden_cfg': self.golden_cfg(), 'stats': dict(self.stats)}}
        tl = []
        for t in self.targets:
            r, az, el, vr = self.polar(t)
            va = ((vr + 25) % 50) - 25
            th = 2 * math.pi * (2 * vr / LAMBDA) / PRF
            mti = 16 * math.sin(th / 2) ** 4 / 6
            mti_db = 10 * math.log10(max(mti, 1e-6))
            tl.append({'id': t['id'], 'enabled': t['enabled'], 'range_km': round(r / 1e3, 2),
                       'az': round(az, 2), 'el': round(el, 2), 'speed': t['speed'],
                       'heading': t['heading'], 'climb': t['climb'], 'snr_db': t['snr_db'],
                       'vr': round(vr, 1), 'v_alias': round(va, 1),
                       'mti_db': round(mti_db, 1), 'blind': mti_db < -6, 'alt_m': round(float(t['pos'][2]))})
        return {'mode': 'synth', 'radar': dict(self.radar), 'scan': dict(self.scan), 'targets': tl,
                'frozen': self.frozen, 'noise_sigma': self.noise_sigma,
                'dr_m': DR, 'max_range_m': DR * NR, 't_cpi': T_CPI}


class Engine(threading.Thread):
    def __init__(self, scene, link, hub):
        super().__init__(daemon=True)
        self.scene, self.link, self.hub = scene, link, hub
        self.connected = False
        self.cpi = 0
        self.sim_t = 0.0
        self.rt_factor = 0.0
        self.err = ''

    def ensure_link(self):
        if self.connected:
            return True
        try:
            self.link.connect()
            self.connected = True
            self.scene.radar_dirty = True
            self.err = ''
        except (OSError, ConnectionError) as e:
            self.err = 'baglanti yok: %s' % e
            self.hub.publish('status', self.status())
            time.sleep(2)
            return False
        return True

    def status(self):
        return {'link': self.link.name, 'connected': self.connected, 'cpi': self.cpi,
                'sim_t': round(self.sim_t, 2), 'rt': round(self.rt_factor, 2), 'err': self.err,
                'speed': self.scene.speed}

    def load_src(self):
        src = self.scene.src

        def prog(i, n):
            print('senaryo yukleniyor: %d / %d CPI' % (i, n), flush=True)
        try:
            t0 = time.monotonic()
            src.load(prog)
            print('senaryo hazir: %d CPI, %.1f s' % (src.n, time.monotonic() - t0), flush=True)
        except (OSError, ValueError, IndexError) as e:
            self.err = 'senaryo okunamadi: %s' % e
            print(self.err, flush=True)

    def run(self):
        rng = np.random.default_rng()
        wall0, sim0 = time.monotonic(), 0.0
        last_state = 0.0
        spd_prev = self.scene.speed
        if self.scene.src:
            threading.Thread(target=self.load_src, daemon=True).start()
        while True:
            sc = self.scene
            if sc.speed != spd_prev:
                spd_prev = sc.speed
                wall0, sim0 = time.monotonic(), self.sim_t
            if not self.ensure_link():
                continue
            if sc.frozen:
                time.sleep(0.05)
                wall0, sim0 = time.monotonic(), self.sim_t
                now = time.monotonic()
                if now - last_state > 0.5:
                    last_state = now
                    with sc.lock:
                        self.hub.publish('state', sc.snapshot())
                    self.hub.publish('status', self.status())
                continue
            try:
                with sc.lock:
                    if sc.radar_dirty:
                        r = sc.radar
                        self.link.config(int(r['k']), float(r['tf']), int(r['gap']), float(r['ratio']))
                        sc.radar_dirty = False
                        sc.reset_stats()
                    exp, ci, t_ev, lit = None, None, None, []
                    if sc.src is None:
                        sc.step_beam()
                        sc.advance()
                        words, az, el, lit = sc.synth(rng)
                        bar = sc.bar
                    else:
                        item = sc.src_next()
                        words = None if item is None else item[0]
                        if item is not None:
                            _, az, el, bar, t_ev, exp, ci = item
                if words is None:
                    src = sc.src
                    if not self.err.startswith('senaryo okunamadi'):
                        self.err = 'senaryo yukleniyor: %d / %d CPI' % (src.loaded, src.n)
                    self.hub.publish('status', self.status())
                    time.sleep(0.2)
                    wall0, sim0 = time.monotonic(), self.sim_t
                    continue
                if self.err.startswith('senaryo yukleniyor'):
                    self.err = ''
                self.cpi += 1
                res = self.link.run(np.ascontiguousarray(words), self.cpi)
            except (OSError, ConnectionError, RuntimeError, struct.error) as e:
                self.connected = False
                self.link.close()
                self.err = str(e)
                continue

            self.sim_t += T_CPI
            got = [int(i) for i in res['idx']]
            dets = [{'r': round(i * DR, 1), 'idx': i} for i in got]
            ev = {'n': self.cpi, 't': round(self.sim_t if t_ev is None else t_ev, 3), 'az': round(az, 3),
                  'el': round(el, 2), 'bar': bar, 'dets': dets, 'lit': lit,
                  'st': res['status'], 'lat_us': round(res['lat_clk'] / 100.0, 1)}
            if exp is not None:
                with sc.lock:
                    exact, near = sc.score(exp, got, res['status'])
                ev.update({'ci': ci, 'exp': exp, 'exact': exact, 'near': near})
            self.hub.publish('cpi', ev)
            wall = time.monotonic() - wall0
            ahead = (self.sim_t - sim0) / sc.speed - wall if sc.speed > 0 else 0
            if ahead > 0:
                time.sleep(ahead)
            wall = time.monotonic() - wall0
            self.rt_factor = (self.sim_t - sim0) / wall if wall > 0 else 0
            if wall > 5:
                wall0, sim0 = time.monotonic(), self.sim_t
            now = time.monotonic()
            if now - last_state > 0.25:
                last_state = now
                with sc.lock:
                    self.hub.publish('state', sc.snapshot())
                self.hub.publish('status', self.status())


class Hub:
    def __init__(self):
        self.lock = threading.Lock()
        self.clients = []

    def subscribe(self):
        q = queue.Queue(maxsize=500)
        with self.lock:
            self.clients.append(q)
        return q

    def unsubscribe(self, q):
        with self.lock:
            if q in self.clients:
                self.clients.remove(q)

    def publish(self, ev, data):
        msg = ('event: %s\ndata: %s\n\n' % (ev, json.dumps(data))).encode()
        with self.lock:
            for q in self.clients:
                try:
                    q.put_nowait(msg)
                except queue.Full:
                    pass


def apply_cmd(scene, c):
    op = c.get('op')
    with scene.lock:
        if scene.src and op in ('scan', 'noise', 'target_add', 'target_update', 'target_del', 'reset_targets'):
            return {'error': 'senaryo modunda kapali'}
        if op == 'scenario' and scene.src:
            s = scene.src
            a = c.get('action')
            if a == 'restart':
                s.i = 0
                scene.reset_stats()
            elif a == 'seek':
                s.i = int(min(max(int(c.get('i', 0)), 0), s.n - 1))
                scene.reset_stats()
            elif a == 'speed':
                scene.speed = float(min(max(float(c.get('v', 1)), 0), 20))
            elif a == 'golden_cfg':
                scene.radar = dict(s.cfg)
                scene.radar_dirty = True
            else:
                return {'error': 'bilinmeyen action'}
            return {'ok': True}
        if op == 'radar':
            for k in ('k', 'tf', 'gap', 'ratio'):
                if k in c:
                    scene.radar[k] = c[k]
            scene.radar['k'] = int(min(max(int(scene.radar['k']), 1), 30))
            scene.radar['tf'] = float(min(max(float(scene.radar['tf']), 1.01), 1000))
            scene.radar['gap'] = int(min(max(int(scene.radar['gap']), 1), 999))
            scene.radar['ratio'] = float(min(max(float(scene.radar['ratio']), 0.01), 0.99))
            scene.radar_dirty = True
        elif op == 'scan':
            for k in scene.scan:
                if k in c:
                    scene.scan[k] = float(c[k])
            scene.scan['bars'] = int(min(max(int(scene.scan['bars']), 1), 8))
            scene.scan['az_span'] = min(max(scene.scan['az_span'], 2), 120)
            scene.scan['rate'] = min(max(scene.scan['rate'], 1), 300)
            scene.bar %= scene.scan['bars']
        elif op == 'noise':
            scene.noise_sigma = float(min(max(float(c.get('sigma', NOISE_SIGMA)), 1), 8000))
        elif op == 'target_add':
            p = {'range_km': 80, 'az': scene.scan['az_center'], 'el': scene.scan['el_center'],
                 'speed': 200, 'heading': (scene.scan['az_center'] + 180) % 360, 'climb': 0, 'snr_db': 12}
            p.update({k: v for k, v in c.items() if k != 'op'})
            return {'id': scene.add_target(p)}
        elif op == 'target_update':
            for t in scene.targets:
                if t['id'] == c.get('id'):
                    scene._set_target(t, c)
        elif op == 'target_del':
            scene.targets = [t for t in scene.targets if t['id'] != c.get('id')]
        elif op == 'reset_targets':
            scene.reset_targets()
        elif op == 'freeze':
            scene.frozen = bool(c.get('on', not scene.frozen))
        else:
            return {'error': 'bilinmeyen op'}
    return {'ok': True}


def make_handler(scene, hub, root):
    class H(BaseHTTPRequestHandler):
        def log_message(self, *a):
            pass

        def _json(self, obj, code=200):
            b = json.dumps(obj).encode()
            self.send_response(code)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(b)))
            self.end_headers()
            self.wfile.write(b)

        def do_GET(self):
            if self.path in ('/', '/index.html'):
                with open(os.path.join(root, 'index.html'), 'rb') as f:
                    b = f.read()
                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                self.send_header('Content-Length', str(len(b)))
                self.end_headers()
                self.wfile.write(b)
            elif self.path == '/state':
                with scene.lock:
                    self._json(scene.snapshot())
            elif self.path == '/events':
                self.send_response(200)
                self.send_header('Content-Type', 'text/event-stream')
                self.send_header('Cache-Control', 'no-cache')
                self.end_headers()
                q = hub.subscribe()
                try:
                    with scene.lock:
                        self.wfile.write(('event: state\ndata: %s\n\n' % json.dumps(scene.snapshot())).encode())
                    self.wfile.flush()
                    while True:
                        try:
                            msg = q.get(timeout=10)
                        except queue.Empty:
                            msg = b': ping\n\n'
                        self.wfile.write(msg)
                        self.wfile.flush()
                except (BrokenPipeError, ConnectionResetError, OSError):
                    pass
                finally:
                    hub.unsubscribe(q)
            else:
                self.send_error(404)

        def do_POST(self):
            if self.path != '/cmd':
                self.send_error(404)
                return
            n = int(self.headers.get('Content-Length', 0))
            try:
                c = json.loads(self.rfile.read(n) or b'{}')
                self._json(apply_cmd(scene, c))
            except (ValueError, TypeError) as e:
                self._json({'error': str(e)}, 400)

    return H


def main():
    ap = argparse.ArgumentParser(description='KV260 FCR tarzi radar ekrani')
    ap.add_argument('--board', default='192.168.137.234:5001', help='radar_server adresi')
    ap.add_argument('--model', action='store_true', help='kart yerine yazilim modeliyle calis')
    ap.add_argument('--http', type=int, default=8080, help='web portu')
    ap.add_argument('--scenario', help='Can\'in vektor klasoru (manifest.json + cpi_XXXX)')
    ap.add_argument('--speed', type=float, default=1.0, help='senaryo hizi (0 = olabildigince hizli)')
    a = ap.parse_args()

    scene = Scene()
    if a.scenario:
        scene.use_scenario(ScenarioSource(a.scenario))
        scene.speed = a.speed
    hub = Hub()
    if a.model:
        link = ModelLink()
    else:
        h, p = a.board.split(':')
        link = BoardLink(h, int(p))
    Engine(scene, link, hub).start()
    root = os.path.dirname(os.path.abspath(__file__))
    srv = ThreadingHTTPServer(('0.0.0.0', a.http), make_handler(scene, hub, root))
    srv.daemon_threads = True
    print('FCR ekrani: http://localhost:%d  (%s%s)' % (a.http, link.name,
          ', senaryo ' + scene.src.name if scene.src else ''), flush=True)
    srv.serve_forever()


if __name__ == '__main__':
    main()
