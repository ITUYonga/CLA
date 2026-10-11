function gen_gold(testCase, N, L, XLEN, AMP, bitrev, outdir)
% GEN_GOLD  tb_fftRTL icin giris ve altin cikis vektorlerini uretir.
%
%   gen_gold(0)                          % impuls @ n=0, varsayilanlarla
%   gen_gold(1, 128, 18, 20, 4096, true) % impuls @ n=1, bit-reversed cikis
%
% Uretilen dosyalar (outdir icine):
%   in.mem       L satir      giris ornekleri (TEST_CASE=3 icin)
%   gold_re.mem  N satir      altin cikis, REEL kisim
%   gold_im.mem  N satir      altin cikis, SANAL kisim
%
% ------------------------------------------------------------------------
% testCase:
%   0 = impuls @ n=0   -> tum X[k] esit (AMP). Twiddle'dan BAGIMSIZ test.
%   1 = impuls @ n=1   -> X[k] = AMP * W^k. Reel kisim kosinus.
%   2 = DC (L adet AMP)-> sifir dolgulu sinc.
%   3 = rastgele       -> genel dogrulama.
%
% bitrev:
%   RTL cikisi BIT-REVERSED sirada geliyorsa true ver. SDF/DIF mimarisinde
%   cikis her zaman bit-reversed'dir, yani normalde true olmali. Once false
%   ile deneyip sekli gozle karsilastirmak da mumkun.
%
% AMP:
%   TB'deki AMP ile AYNI olmali (varsayilan 1<<12 = 4096).
% ------------------------------------------------------------------------

if nargin < 1, testCase = 0;      end
if nargin < 2, N        = 128;    end
if nargin < 3, L        = 18;     end
if nargin < 4, XLEN     = 20;     end
if nargin < 5, AMP      = 2^12;   end
if nargin < 6, bitrev   = true;   end
if nargin < 7, outdir   = '.';    end

if ~exist(outdir, 'dir'), mkdir(outdir); end

x = zeros(1, L);
switch testCase
    case 0
        x(1) = AMP;
        desc = 'impuls @ n=0';
    case 1
        x(2) = AMP;
        desc = 'impuls @ n=1';
    case 2
        x(1:L) = AMP;
        desc = 'DC';
    case 3
        rng(1);                                  % tekrarlanabilir
        x = round((rand(1,L) - 0.5) * 2 * AMP);
        desc = 'rastgele';
    otherwise
        error('testCase 0..3 olmali');
end

% sifir dolgu + FFT
xp = [x, zeros(1, N-L)];
X  = fft(xp, N);

if bitrev
    X = bitrevorder(X);
    ordTxt = 'BIT-REVERSED';
else
    ordTxt = 'dogal';
end

Xr = round(real(X));
Xi = round(imag(X));

% XLEN'e sigiyor mu kontrol et
lim = 2^(XLEN-1);
if max(abs([Xr Xi])) >= lim
    warning(['Cikis %d bite sigmiyor (max |X| = %d, sinir = %d). ' ...
             'AMP degerini dusur ya da XLEN artir.'], ...
             XLEN, max(abs([Xr Xi])), lim);
end

writeMem(fullfile(outdir, 'in.mem'),      round(x), XLEN);
writeMem(fullfile(outdir, 'gold_re.mem'), Xr,       XLEN);
writeMem(fullfile(outdir, 'gold_im.mem'), Xi,       XLEN);

fprintf('--- gen_gold: %s, N=%d, L=%d, AMP=%d, %s sira ---\n', ...
        desc, N, L, AMP, ordTxt);
fprintf('in.mem       : %d satir\n', L);
fprintf('gold_re.mem  : %d satir\n', N);
fprintf('gold_im.mem  : %d satir\n', N);
fprintf('ilk 4 altin deger:\n');
for k = 1:4
    fprintf('   X[%d] = %8d %+8dj\n', k-1, Xr(k), Xi(k));
end
fprintf('tepe |X| = %d\n', round(max(abs(X))));
end

% =========================================================================
function writeMem(fname, v, W)
% Isaretli tamsayilari W-bit iki tumleyen hex olarak yazar.
nh  = ceil(W/4);
u   = mod(v(:), 2^W);
fid = fopen(fname, 'w');
if fid < 0, error('dosya acilamadi: %s', fname); end
for n = 1:numel(u)
    fprintf(fid, '%0*x\n', nh, u(n));
end
fclose(fid);
end