function info = func_export_vectors(out_dir, rx, t_pulse, cfg, scn)
%FUNC_EXPORT_VECTORS : Writes the FPGA test vector folder (stimulus + expected outputs)
%
%   Purpose:  Quantizes the received signal to 16 bit (this is what the FPGA
%             really sees) and writes it with the expected output of every
%             block of the chain as .mem files ($readmemh). The expected
%             outputs are calculated from the quantized input, so the
%             difference between the FPGA and the vector comes only from the
%             arithmetic of the blocks. They are the float results rounded to
%             the same integer grid, they are NOT bit accurate.
%             Spec: docs/FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md
%
%   inputs:
%             out_dir:   Output folder (created if it does not exist)
%             rx:        Received signal, N_PRI x N_Pulse complex (float)
%             t_pulse:   Transmitted pulse, 1 x N_Pulse_Sample complex (NOT windowed)
%             cfg:       Struct with the chain parameters
%                        NFFT, num_ref, num_guard, k, threshold_factor,
%                        peak_ratio, max_gap
%             scn:       Struct that describes the scenario
%                        name, seed, R, v, rcs, Gt_eff, Gt_max
%
%    output:
%             info:      Struct with the written file names and the number of
%                        saturated samples of every tap

    % Fixed choices of the vector format (see the spec, sections 5 and 6)
    scale_shift = 31;                 % rx integer = round(rx * 2^31), 2^-16 is full scale of 16 bit
    tx_shift    = 14;                 % pulse coefficients in Q2.14 (1.0 = 16384)
    w.tx        = 16;                 % Bit width of every tap. Only the input widths are fixed,
    w.rx        = 16;                 % the others are assumptions (RTL has XLEN_IN, XLEN_CONV, XLEN_MTI)
    w.matched   = 18;
    w.mti       = 20;
    w.mti_win   = 20;
    w.fft       = 24;
    w.pow       = 40;                 % power values (|x|^2 and thresholds) use the scale 2^62
    w.det       = 16;                 % detection buffer words
    MAXDET      = 16;                 % size of the detection buffer

    if ~exist(out_dir, 'dir'), mkdir(out_dir); end
    scale = 2^scale_shift;

    info.out_dir = out_dir;
    info.files   = {};

    %% T0: windowed pulse (matched filter coefficients), Q2.14
    h_win = func_window_processing(t_pulse);
    [h_int, info.n_sat.tx] = quant_int(h_win, 2^tx_shift, w.tx);
    info.files = [info.files, write_complex(out_dir, 't0_tx_pulse_win', h_int, w.tx, 'col')];

    %% T1: received signal, 16 bit
    [rx_int, info.n_sat.rx] = quant_int(rx, scale, w.rx);
    info.files = [info.files, write_complex(out_dir, 't1_rx', rx_int, w.rx, 'col')];

    %% Expected outputs: the chain runs on the quantized input (what the FPGA gets)
    rx_q = rx_int / scale;
    c_q  = run_chain(rx_q, h_win, cfg);
    c_f  = run_chain(rx,   h_win, cfg);          % float input, only to compare the detections

    [x, info.n_sat.matched] = quant_int(c_q.matched, scale, w.matched);
    info.files = [info.files, write_complex(out_dir, 't2_matched', x, w.matched, 'col')];

    [x, info.n_sat.mti] = quant_int(c_q.mti, scale, w.mti);
    info.files = [info.files, write_complex(out_dir, 't3_mti', x, w.mti, 'col')];

    [x, info.n_sat.mti_win] = quant_int(c_q.mti_win, scale, w.mti_win);
    info.files = [info.files, write_complex(out_dir, 't4_mti_win', x, w.mti_win, 'col')];

    [x, info.n_sat.fft] = quant_int(c_q.fft, scale, w.fft);
    info.files = [info.files, write_complex(out_dir, 't5_fft', x, w.fft, 'row')];

    [x, info.n_sat.threshold] = quant_int(c_q.threshold, scale^2, w.pow);
    info.files = [info.files, write_real(out_dir, 't6a_os_threshold', real(x), w.pow, 'row')];

    [x, info.n_sat.cfar_out] = quant_int(c_q.cfar_out, scale^2, w.pow);
    info.files = [info.files, write_real(out_dir, 't6b_os_cfar_out', real(x), w.pow, 'row')];

    %% T7: detections. Words: count, idx(1..MAXDET) 0 based and ascending, overflow flag
    det0 = c_q.detected - 1;
    n    = numel(det0);
    words = zeros(MAXDET + 2, 1);
    words(1) = min(n, MAXDET);
    words(2 : 1 + min(n, MAXDET)) = det0(1 : min(n, MAXDET));
    words(end) = n > MAXDET;
    write_mem(fullfile(out_dir, 't7_detected.mem'), words, w.det);
    info.files = [info.files, {'t7_detected.mem'}];

    info.detected_quantized = c_q.detected;      % 1 based (MATLAB), same as main_radar_sim
    info.detected_float     = c_f.detected;

    %% manifest.json: everything needed to use and to reproduce the vector
    [~, ~, ~, target_idx, valid, pattern_dB, hit_each] = ...
        func_score_detections(c_q.detected, scn.R, scn.v, scn.Gt_eff, scn.Gt_max);

    m.name            = scn.name;
    m.repo_commit     = git_text('rev-parse --short HEAD');
    m.repo_has_uncommitted_changes = ~isempty(git_text('status --porcelain -- . ":(exclude)vectors"'));   % the vectors folder itself does not count
    m.rng_seed        = scn.seed;
    m.parameters      = cfg;
    m.format.scale_shift        = scale_shift;
    m.format.scale_note         = 'integer = round(value * 2^scale_shift); power values (threshold, cfar_out) use 2^(2*scale_shift)';
    m.format.tx_pulse_shift     = tx_shift;
    m.format.bit_width          = w;
    m.format.max_detections     = MAXDET;
    m.format.index_base         = 0;
    m.format.order_col          = 'x(:) : pulse-major, one PRI after the other (t0, t1, t2, t3, t4)';
    m.format.order_row          = 'x.''(:) : range-major, all Doppler bins of a range cell together (t5, t6a, t6b)';
    m.format.t7_words           = 'count, idx(1..max_detections) 0 based and ascending, overflow flag';
    m.format.note               = 'Expected values are float results rounded to the integer grid (level A), not bit accurate.';
    m.saturated_samples         = info.n_sat;
    m.expected.detected_idx0            = as_list(c_q.detected - 1);
    m.expected.detected_idx0_float_input = as_list(c_f.detected - 1);
    m.expected.detected_range_m         = as_list((c_q.detected - 1) * 3e8 / (2 * cfg.fs));
    m.targets.range_m         = as_list(scn.R);
    m.targets.velocity_mps    = as_list(scn.v);
    m.targets.rcs_m2          = as_list(scn.rcs);
    m.targets.cell_idx0       = as_list(target_idx - 1);
    m.targets.pattern_dB      = as_list(pattern_dB);
    m.targets.valid           = as_list(valid);
    m.targets.detected        = as_list(hit_each);
    m.targets.note            = 'valid = moving and inside the -3 dB beam. Detected if a detection is within 5 cells.';

    fid = fopen(fullfile(out_dir, 'manifest.json'), 'w');
    fprintf(fid, '%s\n', jsonencode(m, 'PrettyPrint', true));
    fclose(fid);
    info.files = [info.files, {'manifest.json'}];
end


%% ------------------------------------------------------------------------
function c = as_list(x)
% Keeps a one element vector a JSON list (jsonencode turns it into a number otherwise)

    c = num2cell(x(:)');
end

function txt = git_text(args)
% Output of a git command run in the folder of this file ('' if git is not available)

    here = fileparts(mfilename('fullpath'));
    [status, out] = system(['git -C "' here '" ' args]);
    if status ~= 0, txt = 'unknown'; else, txt = strtrim(out); end
end


%% ------------------------------------------------------------------------
function c = run_chain(rx_in, h_win, cfg)
% Same as steps 2-6 of main_radar_sim.m (h_win: the windowed pulse)

    c.matched   = func_matched(h_win, rx_in);
    c.mti       = func_mti(c.matched);
    c.mti_win   = func_window_processing(c.mti);
    c.fft       = func_fft_processing(c.mti_win, cfg.NFFT);
    [c.cfar_out, c.threshold] = func_os_cfar(c.fft, cfg.num_ref, cfg.num_guard, cfg.k, cfg.threshold_factor);
    c.detected  = func_cfar_post_processing(c.fft, c.threshold, cfg.peak_ratio, cfg.max_gap);
end


%% ------------------------------------------------------------------------
function [q, n_sat] = quant_int(x, scale, W)
% Rounds x*scale to integers and saturates them to W bit (signed).
% Complex input is handled as two independent real numbers (real, imag).

    lim = 2^(W-1);
    q_re = round(real(x) * scale);
    q_im = round(imag(x) * scale);
    n_sat = nnz(q_re > lim-1 | q_re < -lim) + nnz(q_im > lim-1 | q_im < -lim);
    q = complex(max(min(q_re, lim-1), -lim), max(min(q_im, lim-1), -lim));
end

function names = write_complex(out_dir, name, x, W, order)
% Writes the real and imaginary parts to <name>_re.mem and <name>_im.mem.
% order 'col': x(:)     (pulse-major, one PRI after the other)
% order 'row': x.'(:)   (range-major, all Doppler bins of a range cell together)

    names = { [name '_re.mem'], [name '_im.mem'] };
    write_mem(fullfile(out_dir, names{1}), order_vec(real(x), order), W);
    write_mem(fullfile(out_dir, names{2}), order_vec(imag(x), order), W);
end

function names = write_real(out_dir, name, x, W, order)
% Writes a real matrix to <name>.mem (same ordering rules as write_complex).

    names = { [name '.mem'] };
    write_mem(fullfile(out_dir, names{1}), order_vec(x, order), W);
end

function v = order_vec(x, order)
    if strcmp(order, 'row')
        x = x.';
    end
    v = x(:);
end

function write_mem(fname, v, W)
% Writes signed integers as W bit two's complement hex, one per line
% ($readmemh format, same as matlab/genGold.m).

    nh  = ceil(W / 4);
    u   = mod(v(:), 2^W);
    fid = fopen(fname, 'w');
    if fid < 0, error('func_export_vectors: cannot open %s', fname); end
    fprintf(fid, ['%0' num2str(nh) 'x\n'], uint64(u));
    fclose(fid);
end
