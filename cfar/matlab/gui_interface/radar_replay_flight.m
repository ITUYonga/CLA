function R = radar_replay_flight(vecDir, boardIP, nMax, doPlot)
% radar_replay_flight  Can'in ucus vektor setini (vec_flight_40s_nfft128) karta akitir,
% her CPI'in sonucunu t7_detected.mem ile karsilastirir.
%   R = radar_replay_flight()                                   varsayilan klasor, tum CPI'lar
%   R = radar_replay_flight(vecDir, "192.168.1.34")              kartin IP'si
%   R = radar_replay_flight(vecDir, "192.168.1.34", 200)         ilk 200 CPI
%   R = radar_replay_flight(vecDir, "192.168.1.34", [], false)   grafik cizme

if nargin < 1 || isempty(vecDir)
    vecDir = "D:/github/RoC-CFAR/golden_model/vectors/vec_flight_40s_nfft128/";
end
if nargin < 2 || isempty(boardIP), boardIP = "192.168.1.106"; end
if nargin < 3, nMax = []; end
if nargin < 4 || isempty(doPlot), doPlot = true; end

port  = 5001;
MAGIC = uint16(hex2dec('5244'));
MAXDET = 16;

m = jsondecode(fileread(fullfile(vecDir, "manifest.json")));
nCpi = m.n_cpi;
if ~isempty(nMax), nCpi = min(nCpi, nMax); end
cc = m.cfar_cfg;
fprintf("Set: %s, %d CPI (%.1f s), k=%d TF=%g gap=%d ratio=%g\n", m.name, nCpi, ...
        nCpi * m.cpi_duration_s, cc.k, cc.threshold_factor, cc.max_gap, cc.peak_ratio);

txRe = readHex(fullfile(vecDir, "t0_tx_pulse_win_re.mem"));
txIm = readHex(fullfile(vecDir, "t0_tx_pulse_win_im.mem"));
assert(numel(txRe) == 20, "t0 boyutu hatali");

t = tcpclient(boardIP, port, "Timeout", 5, "ConnectTimeout", 5);
sendMsg(t, MAGIC, 3, 0, uint8([]));
recvMsg(t, MAGIC, 131, 0);

alpha    = round(log2(cc.threshold_factor) * 1024);
logRatio = round(log2(cc.peak_ratio) * 1024);
cfg = [typecast(uint32(cc.k),'uint8'), typecast(int32(alpha),'uint8'), ...
       typecast(int32(logRatio),'uint8'), typecast(uint32(cc.max_gap),'uint8'), packIQ(txRe, txIm)];
sendMsg(t, MAGIC, 1, 0, cfg);
a = typecast(recvMsg(t, MAGIC, 129, 0), 'int32');
if a(1) ~= 0, error("CONFIG reddedildi (status=%d)", a(1)); end
fprintf("CONFIG ok: k=%d alpha=%d logRatio=%d maxGap=%d\n", a(2:5));

R.exp   = cell(nCpi, 1);
R.got   = cell(nCpi, 1);
R.exact = false(nCpi, 1);
R.near  = false(nCpi, 1);
R.status = zeros(nCpi, 1);
R.latUs  = zeros(nCpi, 1);
R.rttMs  = zeros(nCpi, 1);
R.t       = m.per_cpi.t(1:nCpi);
R.beam_az = m.per_cpi.beam_az(1:nCpi);
R.beam_el = m.per_cpi.beam_el(1:nCpi);

tAll = tic;
for i = 1:nCpi
    d = fullfile(vecDir, sprintf("cpi_%04d", i - 1));
    rxRe = readHex(fullfile(d, "t1_rx_re.mem"));
    rxIm = readHex(fullfile(d, "t1_rx_im.mem"));
    w7   = readHex(fullfile(d, "t7_detected.mem"), false);
    nExp = w7(1);
    R.exp{i} = double(w7(2:1+min(nExp, MAXDET))).';

    tt = tic;
    sendMsg(t, MAGIC, 2, mod(i, 65536), packIQ(rxRe, rxIm));
    w = typecast(recvMsg(t, MAGIC, 130, mod(i, 65536)), 'uint32');
    R.rttMs(i) = toc(tt) * 1000;

    R.status(i) = w(1);
    R.got{i}    = double(w(7:6+min(w(2), MAXDET))).';
    R.latUs(i)  = double(w(4)) / 100;
    R.exact(i)  = isequal(R.got{i}, R.exp{i});
    R.near(i)   = numel(R.got{i}) == numel(R.exp{i}) && all(abs(R.got{i} - R.exp{i}) <= 1);

    if ~R.near(i) && sum(~R.near(1:i)) <= 10
        fprintf("CPI %4d  t=%5.2f s  az=%5.1f  beklenen [%s]  kart [%s]\n", i - 1, R.t(i), ...
                R.beam_az(i), num2str(R.exp{i}), num2str(R.got{i}));
    end
    if mod(i, 250) == 0
        fprintf("  %d / %d CPI, %.1f CPI/s\n", i, nCpi, i / toc(tAll));
    end
end
elapsed = toc(tAll);
clear t

nDetExp = sum(cellfun(@numel, R.exp));
nDetGot = sum(cellfun(@numel, R.got));
fprintf("\n=== SONUC ===\n");
fprintf("Birebir ayni     : %d / %d CPI (%.1f%%)\n", sum(R.exact), nCpi, 100 * mean(R.exact));
fprintf("+-1 hucre icinde : %d / %d CPI (%.1f%%)\n", sum(R.near), nCpi, 100 * mean(R.near));
fprintf("Toplam tespit    : golden %d, kart %d\n", nDetExp, nDetGot);
fprintf("Hata durumu      : %d CPI status != 0\n", sum(R.status ~= 0));
fprintf("PL gecikme       : ort %.0f us, maks %.0f us\n", mean(R.latUs), max(R.latUs));
fprintf("Gidis-donus      : ort %.1f ms, maks %.1f ms\n", mean(R.rttMs), max(R.rttMs));
fprintf("Akis hizi        : %.1f CPI/s (gercek zaman icin 50 CPI/s gerekir, dosya okuma dahil)\n", nCpi / elapsed);

if doPlot
    figure("Name", "Ucus seti: golden vs kart");
    subplot(2,1,1); hold on; grid on;
    [te, re] = flatten(R.t, R.exp);
    [tg, rg] = flatten(R.t, R.got);
    plot(te, re * 0.15, "o", "Color", [0.2 0.6 1], "DisplayName", "golden");
    plot(tg, rg * 0.15, "x", "Color", [1 0.3 0.2], "DisplayName", "kart");
    xlabel("t (s)"); ylabel("menzil (km)"); legend("Location", "best");
    title(sprintf("Tespitler (birebir %.1f%%, +-1 hucre %.1f%%)", 100*mean(R.exact), 100*mean(R.near)));
    subplot(2,1,2); hold on; grid on;
    plot(R.t, R.beam_az, "b-");
    bad = ~R.near;
    plot(R.t(bad), R.beam_az(bad), "r.", "MarkerSize", 14);
    xlabel("t (s)"); ylabel("huzme az (deg)"); title("Huzme azimutu (kirmizi = uyusmayan CPI)");
end
end

function v = readHex(f, signed16)
if nargin < 2, signed16 = true; end
fid = fopen(f, "r");
if fid < 0, error("acilamadi: %s", f); end
v = fscanf(fid, "%x");
fclose(fid);
if signed16
    v(v >= 32768) = v(v >= 32768) - 65536;
    v = int16(v);
end
end

function b = packIQ(re, im)
b = typecast(reshape([int16(re(:)).'; int16(im(:)).'], 1, []), 'uint8');
end

function [tt, rr] = flatten(t, c)
n = cellfun(@numel, c);
tt = repelem(t(:), n(:));
rr = [c{:}].';
if isempty(rr), rr = zeros(0,1); end
end

function sendMsg(t, MAGIC, type, cpi, payload)
h = [typecast(MAGIC,'uint8'), uint8(type), uint8(0), ...
     typecast(uint16(cpi),'uint8'), uint8([0 0]), ...
     typecast(uint32(numel(payload)),'uint8')];
write(t, [h, uint8(payload(:).')]);
end

function payload = recvMsg(t, MAGIC, replyType, cpi)
while true
    h = read(t, 12, "uint8");
    if numel(h) < 12, error("Karttan cevap gelmedi (timeout)"); end
    h = uint8(h);
    if typecast(h(1:2),'uint16') ~= MAGIC, error("Gecersiz cevap basligi"); end
    len = double(typecast(h(9:12),'uint32'));
    payload = uint8([]);
    if len > 0, payload = uint8(read(t, len, "uint8")); end
    if h(3) == replyType && typecast(h(5:6),'uint16') == uint16(cpi), return; end
end
end
