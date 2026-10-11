function log = func_export_flight_vectors(out_dir, scn, radar_cfg, cfar_cfg, scan_cfg, n_cpi, rng_seed, export_name)
%FUNC_EXPORT_FLIGHT_VECTORS : Writes a long, many-CPI FPGA test vector set (flight scenario)
%Can Ertürk
%
%   Purpose:  Runs the flight scenario CPI loop (same building blocks as
%             func_flight_sim: func_kinematics, func_scan_pattern,
%             func_effective_gain, func_clutter_gen,
%             func_get_received_signal, then the same chain as
%             main_radar_sim.m) and, for every CPI, quantizes the received
%             signal to 16 bit and writes it together with the expected
%             final detection.
%
%             This is a LIGHTWEIGHT format, different from func_export_vectors
%             (single frame, writes every intermediate point T0-T7 for block
%             level debugging). Here only the stimulus (T1 = rx) and the
%             expected result (T7 = detected_idx) are written per CPI, meant
%             for long, continuous runs (Ethernet / timing / many-CPI
%             testing), not block level debugging. T0 (the matched filter
%             coefficient) does not change during the run (no maneuver), so
%             it is written ONCE at the top of the vector set instead of once
%             per CPI folder.
%             For block-by-block (T2-T6) verification use the single-frame
%             'nominal' set (vec_nominal_nfft128/) instead, every block was
%             already validated there against the exact same chain.
%             Spec: docs/FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md section 10 (the
%             per-CPI folder structure follows it; the reduced per-CPI file
%             set is a deliberate, documented simplification for this long
%             run, requested for FPGA continuous-stream testing).
%
%   inputs:
%             out_dir:      Output folder (created if it does not exist)
%             scn:          Scenario struct, same as func_flight_sim
%             radar_cfg:    Radar parameter struct, same as func_flight_sim
%                           (use NFFT = 128 here to match the RTL, not 256)
%             cfar_cfg:     CFAR / post processing struct, same as func_flight_sim
%             scan_cfg:     Scan pattern struct, same as func_flight_sim
%             n_cpi:        Number of CPIs to run and write
%             rng_seed:     Same noise and clutter at every run. [] = different at every run
%             export_name:  Name written to the manifest (for reference only)
%
%    output:
%             log:          Per-CPI summary (same fields as func_flight_sim,
%                           plus n_sat_rx and detected_idx0)
%                           .cpi_id, .t, .beam_az, .beam_el, .bar_idx
%                           .hits, .n_valid, .false_alarms, .n_sat_rx
%                           .detected_idx0 {n_cpi x 1} cell, 0 based

% Same fixed format choices as func_export_vectors (spec sections 5-6)
scale_shift = 31;
tx_shift    = 14;
w.tx  = 16;
w.rx  = 16;
w.det = 16;
MAXDET = 16;
scale  = 2^scale_shift;

if ~exist(out_dir, 'dir'), mkdir(out_dir); end

% Derived radar quantities (same formulas as func_flight_sim / main_radar_sim.m)
PRF            = 1 / radar_cfg.PRI;
lambda         = radar_cfg.c / radar_cfg.fc;
k_lfm          = radar_cfg.B / radar_cfg.tau;
N_PRI          = radar_cfg.fs * radar_cfg.PRI;
N_Pulse_Sample = radar_cfg.fs * radar_cfg.tau;
t_p            = (0:N_Pulse_Sample - 1) / radar_cfg.fs;
Gt_max         = 10^(radar_cfg.Gt_dBi / 10);
CPI_dur        = radar_cfg.N_Pulse * radar_cfg.PRI;

noise_amp   = func_calculate_noise('noisefloor', radar_cfg.noise_floor);
clutter_amp = 10 * noise_amp;

t_pulse     = func_lfm_gen(k_lfm, t_p);
t_pulse_win = func_window_processing(t_pulse);

if ~isempty(rng_seed), rng(rng_seed); end

% T0: matched filter coefficient, constant for the whole run, written ONCE
[h_int, n_sat_tx] = quant_int(t_pulse_win, 2^tx_shift, w.tx);
write_complex(out_dir, 't0_tx_pulse_win', h_int, w.tx, 'col');

log.cpi_id = (1:n_cpi)';
log.t = zeros(n_cpi,1); log.beam_az = zeros(n_cpi,1); log.beam_el = zeros(n_cpi,1); log.bar_idx = zeros(n_cpi,1);
log.hits = zeros(n_cpi,1); log.n_valid = zeros(n_cpi,1); log.false_alarms = zeros(n_cpi,1);
log.n_sat_rx = zeros(n_cpi,1);
log.detected_idx0 = cell(n_cpi,1);

for i = 1:n_cpi
    t = (i - 1) * CPI_dur;

    [R, az, el, v_radial] = func_kinematics(t, scn.ac_lla0, scn.ac_att, scn.ac_vel_ned, ...
                                             scn.tgt_lla, scn.tgt_vel_ned);
    [beam_az, beam_el, bar_idx] = func_scan_pattern(t, scan_cfg.az_center, scan_cfg.az_width, ...
                                                     scan_cfg.az_rate_dps, scan_cfg.el_top, ...
                                                     scan_cfg.el_step, scan_cfg.n_bars);
    Gt_eff = func_effective_gain(radar_cfg.Gt_dBi, az, el, beam_az, beam_el, ...
                                  scn.hpbw_az, scn.hpbw_el, scn.floor_dB);

    clutter = func_clutter_gen(t_pulse, N_PRI, radar_cfg.N_Pulse, clutter_amp, PRF, lambda, radar_cfg.c, radar_cfg.fs);
    rx      = func_get_received_signal(t_pulse, N_PRI, radar_cfg.N_Pulse, R, v_radial, scn.rcs_tgt, ...
                                        radar_cfg.Pt, Gt_eff, noise_amp);
    rx      = rx + clutter;

    % T1: received signal, 16 bit. The chain runs on the QUANTIZED input
    % (what the FPGA actually gets), same as func_export_vectors.
    [rx_int, n_sat] = quant_int(rx, scale, w.rx);
    rx_q = rx_int / scale;

    matched = func_matched(t_pulse_win, rx_q);
    mti     = func_mti(matched);
    mti_win = func_window_processing(mti);
    fft_out = func_fft_processing(mti_win, radar_cfg.NFFT);
    [~, threshold] = func_os_cfar(fft_out, cfar_cfg.num_ref, cfar_cfg.num_guard, cfar_cfg.k, cfar_cfg.threshold_factor);
    detected = func_cfar_post_processing(fft_out, threshold, cfar_cfg.peak_ratio, cfar_cfg.max_gap);

    [hits, n_valid, false_alarms] = func_score_detections(detected, R, v_radial, Gt_eff, Gt_max);

    cpi_dir = fullfile(out_dir, sprintf('cpi_%04d', i - 1));   % 0 based, matches the spec's cpi_0000 convention
    if ~exist(cpi_dir, 'dir'), mkdir(cpi_dir); end
    write_complex(cpi_dir, 't1_rx', rx_int, w.rx, 'col');

    % T7: detections. Words: count, idx(1..MAXDET) 0 based and ascending, overflow flag
    det0 = detected - 1;
    n = numel(det0);
    words = zeros(MAXDET + 2, 1);
    words(1) = min(n, MAXDET);
    words(2 : 1 + min(n, MAXDET)) = det0(1 : min(n, MAXDET));
    words(end) = n > MAXDET;
    write_mem(fullfile(cpi_dir, 't7_detected.mem'), words, w.det);

    log.t(i)        = t;
    log.beam_az(i)  = beam_az;
    log.beam_el(i)  = beam_el;
    log.bar_idx(i)  = bar_idx;
    log.hits(i)         = hits;
    log.n_valid(i)       = n_valid;
    log.false_alarms(i)  = false_alarms;
    log.n_sat_rx(i)      = n_sat;
    log.detected_idx0{i} = det0(:)';
end

%% manifest.json: everything needed to use and to reproduce the set
m.name        = export_name;
m.repo_commit = git_text('rev-parse --short HEAD');
m.repo_has_uncommitted_changes = ~isempty(git_text('status --porcelain -- . ":(exclude)vectors"'));
m.rng_seed          = rng_seed;
m.n_cpi             = n_cpi;
m.cpi_duration_s    = CPI_dur;
m.total_duration_s  = n_cpi * CPI_dur;
m.radar_cfg = radar_cfg;
m.cfar_cfg  = cfar_cfg;
m.scan_cfg  = scan_cfg;
m.scenario  = scn;
m.format.scale_shift    = scale_shift;
m.format.scale_note     = 'integer = round(value * 2^scale_shift), same rx scale as func_export_vectors';
m.format.tx_pulse_shift = tx_shift;
m.format.bit_width      = w;
m.format.max_detections = MAXDET;
m.format.index_base     = 0;
m.format.t0_note        = 'T0 (matched filter coefficient) is constant for the run, written once at the top, NOT repeated per CPI';
m.format.note           = ['Lightweight flight vector set: T0 once (top level) + T1, T7 per cpi_XXXX folder. ' ...
                            'No T2-T6 (block level intermediate outputs) here, see vec_nominal_nfft128 for those.'];
m.saturated_tx = n_sat_tx;
m.per_cpi.t             = as_list(log.t);
m.per_cpi.beam_az       = as_list(log.beam_az);
m.per_cpi.beam_el       = as_list(log.beam_el);
m.per_cpi.bar_idx       = as_list(log.bar_idx);
m.per_cpi.n_valid       = as_list(log.n_valid);
m.per_cpi.hits          = as_list(log.hits);
m.per_cpi.false_alarms  = as_list(log.false_alarms);
m.per_cpi.n_sat_rx      = as_list(log.n_sat_rx);
m.per_cpi.detected_idx0 = cellfun(@as_list, log.detected_idx0, 'UniformOutput', false);   % each CPI's list, always a JSON array (as_list keeps 0/1 element cases from collapsing to a bare number)
m.summary.total_valid        = sum(log.n_valid);
m.summary.total_hits         = sum(log.hits);
m.summary.total_false_alarms = sum(log.false_alarms);
m.summary.pd                 = sum(log.hits) / max(sum(log.n_valid), 1);

fid = fopen(fullfile(out_dir, 'manifest.json'), 'w');
fprintf(fid, '%s\n', jsonencode(m, 'PrettyPrint', true));
fclose(fid);

end


%% ------------------------------------------------------------------------
% Local helpers: same as func_export_vectors.m, duplicated here on purpose
% so the two export functions stay independent (see main README on code style).

function c = as_list(x)
    c = num2cell(x(:)');
end

function txt = git_text(args)
    here = fileparts(mfilename('fullpath'));
    [status, out] = system(['git -C "' here '" ' args]);
    if status ~= 0, txt = 'unknown'; else, txt = strtrim(out); end
end

function [q, n_sat] = quant_int(x, scale, W)
    lim = 2^(W-1);
    q_re = round(real(x) * scale);
    q_im = round(imag(x) * scale);
    n_sat = nnz(q_re > lim-1 | q_re < -lim) + nnz(q_im > lim-1 | q_im < -lim);
    q = complex(max(min(q_re, lim-1), -lim), max(min(q_im, lim-1), -lim));
end

function names = write_complex(out_dir, name, x, W, order)
    names = { [name '_re.mem'], [name '_im.mem'] };
    write_mem(fullfile(out_dir, names{1}), order_vec(real(x), order), W);
    write_mem(fullfile(out_dir, names{2}), order_vec(imag(x), order), W);
end

function v = order_vec(x, order)
    if strcmp(order, 'row')
        x = x.';
    end
    v = x(:);
end

function write_mem(fname, v, W)
    nh  = ceil(W / 4);
    u   = mod(v(:), 2^W);
    fid = fopen(fname, 'w');
    if fid < 0, error('func_export_flight_vectors: cannot open %s', fname); end
    fprintf(fid, ['%0' num2str(nh) 'x\n'], uint64(u));
    fclose(fid);
end
