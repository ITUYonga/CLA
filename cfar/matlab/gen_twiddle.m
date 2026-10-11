function gen_twiddle(N, TWLEN, TWFRAC, outdir, mode)
% GEN_TWIDDLE  SDF FFT icin twiddle ROM dosyalarini uretir.
%
%   gen_twiddle(128, 18, 16, 'tw', 'quarter')   % ceyrek dalga, TEK dosya
%   gen_twiddle(128, 18, 16, 'tw', 'perstage')  % kademe basina ayri dosya
%
% ------------------------------------------------------------------------
% FORMAT: Q2.TWFRAC isaretli, TWLEN bit, hex (iki tumleyen), satir basina bir.
%
% NEDEN Q2.16 (Q1.17 DEGIL):
%   W^0 = 1.0 degeri her kademede TOPLAM yolunda kullanilir. Q1.17'de 1.0
%   temsil edilemez, saturasyona duser ve her kademede kucuk bir kazanc
%   kaybi birikir. Q2.16'da 1.0 = 2^16 = 0x10000 olarak TAM temsil edilir.
%
% TWIDDLE USSU:
%   Kademe i:  W_N^(k * 2^i),  k = 0 .. N/2^(i+1) - 1
%   Adim 2^i'dir cunku kademe ilerledikce DFT tabani yariya iner:
%       W_(N/2^i)^k = W_N^(k * 2^i)
%   En buyuk us = N/2 - 2^i  ->  tum kademeler [0, N/2) araliginda kalir.
%
% CEYREK DALGA (mode = 'quarter'):
%   Sadece cos(2*pi*j/N), j = 0..N/4 saklanir  ->  N/4+1 giris.
%   N=128 icin 33 giris. Tum kademeler AYNI dosyayi kullanir.
%   Simetriden turetme (RTL ile birebir ayni olmali):
%       m <  N/4 :  cos =  T[m]         sin = T[N/4 - m]
%       m >= N/4 :  m' = m - N/4
%                   cos = -T[N/4 - m']  sin = T[m']
%   Twiddle W_N^m = cos - j*sin
% ------------------------------------------------------------------------

if nargin < 1, N      = 128;       end
if nargin < 2, TWLEN  = 18;        end
if nargin < 3, TWFRAC = 16;        end
if nargin < 4, outdir = 'tw';      end
if nargin < 5, mode   = 'quarter'; end

if ~exist(outdir, 'dir'), mkdir(outdir); end

LOGN  = log2(N);
if mod(LOGN,1) ~= 0
    error('N ikinin kuvveti olmali');
end

scale = 2^TWFRAC;
lo    = -2^(TWLEN-1);
hi    =  2^(TWLEN-1) - 1;

% 1.0'in temsil edilebildigini dogrula
if scale > hi
    error(['1.0 = %d, %d-bit Q2.%d formatina sigmiyor. ' ...
           'TWFRAC degerini dusur.'], scale, TWLEN, TWFRAC);
end

fprintf('--- gen_twiddle: N=%d, %d-bit Q2.%d, mod=%s ---\n', ...
        N, TWLEN, TWFRAC, mode);
fprintf('1.0 = %d = 0x%s  (tam temsil)\n', scale, dec2hex(scale, ceil(TWLEN/4)));

switch lower(mode)

% ========================================================================
case 'quarter'
% ========================================================================
    Q = N/4;
    j = (0:Q).';
    T = cos(2*pi*j/N);
    q = min(max(round(T*scale), lo), hi);

    writeMem(fullfile(outdir, 'tw_cos.mem'), q, TWLEN);
    fprintf('tw_cos.mem yazildi: %d giris, %d bit (toplam %d bit)\n', ...
            Q+1, TWLEN, (Q+1)*TWLEN);

    % --- simetri dogrulamasi: RTL'in yapacagi turetmeyi taklit et --------
    maxErr = 0;
    for m = 0:(N/2 - 1)
        if m < Q
            c = q(m+1);        s = q(Q-m+1);
        else
            mp = m - Q;
            c = -q(Q-mp+1);    s = q(mp+1);
        end
        maxErr = max([maxErr, ...
                      abs(c/scale - cos(2*pi*m/N)), ...
                      abs(s/scale - sin(2*pi*m/N))]);
    end
    fprintf('simetri dogrulamasi: max hata = %.3e\n', maxErr);
    fprintf('  (kuantizasyon siniri = %.3e)\n', 0.5/scale);

% ========================================================================
case 'perstage'
% ========================================================================
    total = 0;
    for i = 0 : LOGN-1
        D = N / 2^(i+1);
        if D == 1
            fprintf('kademe %d: D=1, tek twiddle W^0=1 -> dosya uretilmedi\n', i);
            continue;
        end
        k = (0:D-1).';
        m = k * 2^i;                    % us = k * 2^i
        W = exp(-1j * 2*pi * m / N);

        qre = min(max(round(real(W)*scale), lo), hi);
        qim = min(max(round(imag(W)*scale), lo), hi);

        writeMem(fullfile(outdir, sprintf('tw_re_%d.mem', i)), qre, TWLEN);
        writeMem(fullfile(outdir, sprintf('tw_im_%d.mem', i)), qim, TWLEN);

        total = total + 2*D*TWLEN;
        fprintf('kademe %d: D=%3d, adim=%3d, us araligi 0..%d\n', ...
                i, D, 2^i, max(m));
    end
    fprintf('toplam ROM: %d bit\n', total);

otherwise
    error('mode "quarter" veya "perstage" olmali');
end

fprintf('--- bitti ---\n');
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