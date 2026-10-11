function res = radar_host_tcp(nCpi, vecDir, expected, boardIP)
% radar_host_tcp  KV260 radar kartina TCP ile TX/RX gonderir, sonucu okur.
%   res = radar_host_tcp()                          golden nominal seti 1 kez kosar
%   res = radar_host_tcp(100)                       100 CPI art arda
%   res = radar_host_tcp(1, vecDir, [..])           baska vektor seti ([] = kontrol yok)
%   res = radar_host_tcp(1, [], 564, "192.168.1.23") kartin IP'si farkliysa

if nargin < 1 || isempty(nCpi),     nCpi = 1; end
if nargin < 2 || isempty(vecDir)
    vecDir = "D:/github/RoC-CFAR/golden_model/vectors/vec_nominal_nfft128/";
end
if nargin < 3, expected = 564; end
if nargin < 4 || isempty(boardIP),  boardIP = "192.168.137.234"; end

port    = 5001;
k       = 20;
TF      = 8;
peakRat = 0.5;
maxGap  = 15;

NP = 20; NR = 1000;
MAGIC = uint16(hex2dec('5244'));

txRe = readMem(fullfile(vecDir, "t0_tx_pulse_win_re.mem"));
txIm = readMem(fullfile(vecDir, "t0_tx_pulse_win_im.mem"));
rxRe = readMem(fullfile(vecDir, "t1_rx_re.mem"));
rxIm = readMem(fullfile(vecDir, "t1_rx_im.mem"));
assert(numel(txRe) == 20 && numel(rxRe) == NP*NR, "vektor boyutu hatali");

txBytes = packIQ(txRe, txIm);
rxBytes = packIQ(rxRe, rxIm);

fprintf("%s:%d baglaniliyor...\n", boardIP, port);
t = tcpclient(boardIP, port, "Timeout", 5, "ConnectTimeout", 5);

sendMsg(t, MAGIC, 3, 0, uint8([]));
p = recvMsg(t, MAGIC, 131, 0);
p = typecast(p, 'uint32');
fprintf("PING ok: status=0x%X cpiCount=%d k=%d alpha=%d\n", p(1), p(2), p(3), p(4));

alpha    = round(log2(TF) * 1024);
logRatio = round(log2(peakRat) * 1024);
cfg = [typecast(uint32(k),'uint8'), typecast(int32(alpha),'uint8'), ...
       typecast(int32(logRatio),'uint8'), typecast(uint32(maxGap),'uint8'), txBytes];
sendMsg(t, MAGIC, 1, 0, cfg);
a = typecast(recvMsg(t, MAGIC, 129, 0), 'int32');
fprintf("CONFIG ok: status=%d k=%d alpha=%d logRatio=%d maxGap=%d\n", a(1:5));
if a(1) ~= 0, error("TX yuklenemedi (status=%d)", a(1)); end

res = struct('status',{},'count',{},'overflow',{},'latencyClk',{}, ...
             'cpiCount',{},'rxUs',{},'idx',{},'rttMs',{});
nPass = 0;
for c = 1:nCpi
    cpiId = mod(c, 65536);
    tt = tic;
    sendMsg(t, MAGIC, 2, cpiId, rxBytes);
    r = recvMsg(t, MAGIC, 130, cpiId);
    rtt = toc(tt) * 1000;

    w = typecast(r, 'uint32');
    one.status     = w(1);
    one.count      = w(2);
    one.overflow   = w(3);
    one.latencyClk = w(4);
    one.cpiCount   = w(5);
    one.rxUs       = w(6);
    one.idx        = double(w(7:6+min(w(2),16)));
    one.rttMs      = rtt;
    res(end+1) = one; %#ok<AGROW>

    ok = one.status == 0 && (isempty(expected) || isequal(one.idx(:).', double(expected(:).')));
    nPass = nPass + ok;
    if nCpi <= 10 || ~ok || mod(c, 50) == 0
        fprintf("CPI %d: status=%d count=%d idx=[%s] lat=%d clk rx=%.1f ms rtt=%.1f ms %s\n", ...
            c, one.status, one.count, num2str(one.idx), one.latencyClk, ...
            double(one.rxUs)/1000, rtt, ternary(ok, "PASS", "FAIL"));
    end
end
fprintf("\n%d / %d CPI PASS (beklenen [%s])\n", nPass, nCpi, num2str(expected));
clear t
end

function v = readMem(f)
txt = strtrim(readlines(f));
txt = txt(txt ~= "");
v = int32(hex2dec(txt));
v(v >= 32768) = v(v >= 32768) - 65536;
v = int16(v);
end

function b = packIQ(re, im)
b = typecast(reshape([re(:).'; im(:).'], 1, []), 'uint8');
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
    if numel(h) < 12
        error("Karttan cevap gelmedi (timeout)");
    end
    h = uint8(h);
    if typecast(h(1:2),'uint16') ~= MAGIC
        error("Gecersiz cevap basligi");
    end
    len = double(typecast(h(9:12),'uint32'));
    payload = uint8([]);
    if len > 0
        payload = uint8(read(t, len, "uint8"));
    end
    if h(3) == replyType && typecast(h(5:6),'uint16') == uint16(cpi)
        return;
    end
end
end

function o = ternary(c, a, b)
if c, o = a; else, o = b; end
end
