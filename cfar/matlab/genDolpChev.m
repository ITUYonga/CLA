function w = genDolpChev(N, sidelobe_dB, QLEN, QFRAC, outdir, fname)
% GENDOLPCHEV  Dolph-Chebyshev pencere katsayilarini uretir ve .mem yazar.
%
%   genDolpChev(18, 60, 18, 16, 'win', 'win_doppler.mem')   % Doppler penceresi
%   genDolpChev(20, 60, 16, 15, 'win', 'win_tx.mem')        % TX darbe penceresi
%   genDolpChev(20, 60, 17, 15, 'win', 'win_tx.mem')        % TX, tam 1.0 ile
%
% ------------------------------------------------------------------------
% DIKKAT: QLEN/QFRAC PENCERE KATSAYISININ formatidir, VERININ degil.
%
%   Veri yolu (degismez):
%       MTI cikisi Q5.15 (20 bit)
%     x pencere    Q2.16 (18 bit)
%     = Q7.31  ->> 16  ->  Q7.15
%     tepe = 1.0 oldugundan genlik buyumez; alt 20 bit alinir -> Q5.15
%     FFT girisi 20 bit kalir, XLEN degismez.
% ------------------------------------------------------------------------
% FORMAT SECIMI
%
%   Q1.15 (16 bit): 1.0 = 32768 ama maksimum 32767 -> TAM SIGMAZ.
%                   Fonksiyon tepeyi 32767'ye normalize eder (hata 3e-5).
%   Q2.15 (17 bit): 1.0 = 32768, tam sigar.
%   Q2.16 (18 bit): 1.0 = 65536, tam sigar. Doppler icin onerilen.
%
% Tepe her zaman temsil edilebilen en buyuk degere ayarlanir; boylece
% pencere carpimi BIT BUYUMESI YARATMAZ.
% ------------------------------------------------------------------------

if nargin < 1, N           = 18;                end
if nargin < 2, sidelobe_dB = 60;                end
if nargin < 3, QLEN        = 18;                end
if nargin < 4, QFRAC       = 16;                end
if nargin < 5, outdir      = 'win';             end
if nargin < 6, fname       = 'win_doppler.mem'; end

if ~exist(outdir, 'dir'), mkdir(outdir); end

scale = 2^QFRAC;
hi    =  2^(QLEN-1) - 1;
lo    = -2^(QLEN-1);

% --- tepe hedefi: 1.0 sigiyorsa 2^QFRAC, sigmiyorsa en buyuk deger --------
if scale <= hi
    peakTarget = scale;
    exactOne   = true;
else
    peakTarget = hi;
    exactOne   = false;
    warning(['Q%d.%d formatinda 1.0 = %d temsil edilemez (max %d). ' ...
             'Tepe %d''e normalize edildi, hata %.2e. ' ...
             'Tam 1.0 istersen QLEN degerini %d yap.'], ...
             QLEN-QFRAC, QFRAC, scale, hi, hi, 1/scale, QLEN+1);
end

% --- pencereyi uret -------------------------------------------------------
if exist('chebwin', 'file') == 2
    w = chebwin(N, sidelobe_dB);
else
    warning('chebwin yok (Signal Processing Toolbox gerekli). Hamming kullaniliyor.');
    w = hamming(N);
end

w = w(:) / max(w);                       % tepe = 1.0 (kayan noktali)

% --- kuantize -------------------------------------------------------------
q = min(max(round(w * peakTarget), lo), hi);

% --- .mem yaz -------------------------------------------------------------
nh   = ceil(QLEN/4);
u    = mod(q, 2^QLEN);
path = fullfile(outdir, fname);
fid  = fopen(path, 'w');
if fid < 0, error('dosya acilamadi: %s', path); end
for n = 1:numel(u)
    fprintf(fid, '%0*x\n', nh, u(n));
end
fclose(fid);

% --- rapor ----------------------------------------------------------------
[~, iPeak] = max(q);
cg  = sum(w)    / N;                     % koherent kazanc
ng  = sum(w.^2) / N;                     % gurultu kazanci
loss = -10*log10(cg^2 / ng);             % dikdortgene gore islem kaybi

fprintf('--- genDolpChev ---\n');
fprintf('dosya       : %s\n', path);
fprintf('N           : %d katsayi\n', N);
fprintf('yan lob     : %g dB\n', sidelobe_dB);
fprintf('format      : Q%d.%d (%d bit)%s\n', QLEN-QFRAC, QFRAC, QLEN, ...
        merge(exactOne, '', '  [1.0 TAM DEGIL]'));
fprintf('tepe        : indeks %d, deger %d = 0x%s\n', ...
        iPeak-1, q(iPeak), dec2hex(mod(q(iPeak),2^QLEN), nh));
fprintf('sum|h|      : %.3f\n', sum(w));
fprintf('koherent K  : %.4f\n', cg);
fprintf('islem kaybi : %.2f dB\n', loss);
fprintf('ilk 4       : %s\n', mat2str(q(1:min(4,N))'));
fprintf('VERI YOLU   : Q5.15 (20b) x bu pencere -> >>%d -> Q5.15 (20b)\n', QFRAC);
end

% -------------------------------------------------------------------------
function s = merge(cond, a, b)
if cond, s = a; else, s = b; end
end