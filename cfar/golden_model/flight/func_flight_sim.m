function log = func_flight_sim(scn, radar_cfg, cfar_cfg, scan_cfg, n_cpi, rng_seed)
%FUNC_FLIGHT_SIM : CPI loop of the flight (moving) scenario
%Can Ertürk
%
%   Purpose:  Runs the flight scenario (README.md section 14): a radar on a
%             straight and level flying aircraft scans the ground with a
%             snake/raster pattern and processes one CPI (20 ms, N_Pulse
%             pulses) at a time. Every CPI it calls func_kinematics (target
%             geometry and radial velocity at the current time),
%             func_scan_pattern (current beam direction) and then runs the
%             SAME signal processing chain as main_radar_sim.m (matched
%             filter -> MTI -> window -> FFT -> OS-CFAR -> post processing).
%             main_radar_sim.m itself is not touched, this is a separate
%             driver so the existing single-frame scenarios keep working.
%
%             Known simplifications of this first version (see README.md
%             section 14 for the reasoning):
%             - The beam direction is held fixed for the whole CPI (computed
%               once at the start of the CPI), even though a real scan moves
%               a few degrees during 20 ms.
%             - Platform motion is assumed to be ideally compensated for
%               clutter: func_clutter_gen is unchanged, clutter stays at
%               zero Doppler. In reality the aircraft's own speed would
%               shift ground clutter away from zero Doppler and MTI could
%               not cancel it; this is a documented risk, not solved here.
%             - No maneuver: aircraft attitude and velocity are constant.
%
%   inputs:
%             scn:        Scenario struct
%                         .ac_lla0, .ac_att, .ac_vel_ned   (see func_kinematics)
%                         .tgt_lla, .tgt_vel_ned           (see func_kinematics)
%                         .rcs_tgt                          Radar cross section of each target (m^2)
%                         .hpbw_az, .hpbw_el, .floor_dB      Antenna pattern (see func_effective_gain)
%             radar_cfg:  Radar parameter struct, same names/values as main_radar_sim.m
%                         .fs, .fc, .c, .tau, .B, .PRI, .Pt, .Gt_dBi, .noise_floor, .N_Pulse, .NFFT
%             cfar_cfg:   CFAR / post processing struct, same names as main_radar_sim.m
%                         .num_ref, .num_guard, .k, .threshold_factor, .peak_ratio, .max_gap
%             scan_cfg:   Scan pattern struct (see func_scan_pattern)
%                         .az_center, .az_width, .az_rate_dps, .el_top, .el_step, .n_bars
%             n_cpi:      Number of CPIs to run
%             rng_seed:   Same noise and clutter at every run. [] = different at every run
%
%    output:
%             log:        Struct of per-CPI results (N = number of targets)
%                         .cpi_id, .t, .beam_az, .beam_el, .bar_idx   [n_cpi x 1]
%                         .R, .az, .el, .v_radial, .Gt_eff            [N x n_cpi]
%                         .detected_idx                                {n_cpi x 1} cell, range cells (1 based, matched filter convention)
%                         .hits, .n_valid, .false_alarms              [n_cpi x 1] (func_score_detections, per CPI)

if ~isempty(rng_seed), rng(rng_seed); end

% Derived radar quantities (same formulas as main_radar_sim.m section 2)
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

N = size(scn.tgt_lla, 1);

% Preallocated log
log.cpi_id = (1:n_cpi)';
log.t        = zeros(n_cpi, 1);
log.beam_az  = zeros(n_cpi, 1);
log.beam_el  = zeros(n_cpi, 1);
log.bar_idx  = zeros(n_cpi, 1);
log.R        = zeros(N, n_cpi);
log.az       = zeros(N, n_cpi);
log.el       = zeros(N, n_cpi);
log.v_radial = zeros(N, n_cpi);
log.Gt_eff   = zeros(N, n_cpi);
log.detected_idx = cell(n_cpi, 1);
log.hits          = zeros(n_cpi, 1);
log.n_valid       = zeros(n_cpi, 1);
log.false_alarms  = zeros(n_cpi, 1);

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

    matched_output = func_matched(t_pulse_win, rx);
    mti_output     = func_mti(matched_output);
    windowed_output     = func_window_processing(mti_output);
    windowed_fft_output = func_fft_processing(windowed_output, radar_cfg.NFFT);
    [~, os_threshold_map] = func_os_cfar(windowed_fft_output, cfar_cfg.num_ref, cfar_cfg.num_guard, ...
                                          cfar_cfg.k, cfar_cfg.threshold_factor);
    detected_idx = func_cfar_post_processing(windowed_fft_output, os_threshold_map, ...
                                              cfar_cfg.peak_ratio, cfar_cfg.max_gap);

    [hits, n_valid, false_alarms] = func_score_detections(detected_idx, R, v_radial, Gt_eff, Gt_max);

    log.t(i)       = t;
    log.beam_az(i) = beam_az;
    log.beam_el(i) = beam_el;
    log.bar_idx(i) = bar_idx;
    log.R(:,i)        = R(:);
    log.az(:,i)       = az(:);
    log.el(:,i)       = el(:);
    log.v_radial(:,i) = v_radial(:);
    log.Gt_eff(:,i)   = Gt_eff(:);
    log.detected_idx{i} = detected_idx;
    log.hits(i)         = hits;
    log.n_valid(i)       = n_valid;
    log.false_alarms(i)  = false_alarms;
end

end
