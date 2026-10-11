%% MAIN_RADAR_SIM : End to end radar signal processing chain (golden model)
%
%   Purpose:  Generates the received signal of a pulse radar (targets +
%             noise + clutter), runs it through the signal processing chain
%             and evaluates the detections.
%
%   Chain:    rx -> matched filter -> MTI -> Doppler window -> FFT
%                -> OS-CFAR -> post processing -> detected_idx
%
%   How to use:
%             1) Change the choices in section 1 (scenario, seed, plots).
%             2) Change radar, CFAR or target values in sections 2, 3 and 4.
%             3) Press Run. The chain (section 7) does not need any change.

%% 0. WORKSPACE
% -------------------------------------------------------------------------

clear; close all; clc;


%% 1. USER SETTINGS
% -------------------------------------------------------------------------

scenario_mode    = 'lla';       % 'simple' (range + velocity) or 'lla' (aircraft + targets in lat/lon/alt)
rng_seed         = 1;           % Same noise and clutter at every run. [] = different at every run
plot_pipeline    = true;        % Figures of every step of the chain
plot_scenario    = true;        % Antenna pattern and 3D scenario view (only for 'lla')
run_monte_carlo  = false;       % Repeat the chain N_trials times to get average Pd and Pfa (slow)
N_trials         = 50;          % Number of monte carlo trials
export_vectors   = false;       % Write the FPGA test vectors (.mem files) to vectors/ (single frame)
export_name      = 'nominal';   % Name of the vector set
export_NFFT      = 128;         % Doppler FFT size of the vectors (RTL FFT_POINT). Plots use NFFT


%% 2. RADAR PARAMETERS
% -------------------------------------------------------------------------
% Changing these changes the matrix sizes of the whole chain (see section 2.2)

fs               = 1e6;                             % Sampling rate (Hz)
fc               = 3e9;                             % Operating frequency (Hz)
c                = 3e8;                             % Speed of light in free space (m/s)
tau              = 20e-6;                           % Pulse width (s)
B                = 400e3;                           % Bandwidth of the LFM pulse (Hz)
PRI              = 1e-3;                            % Pulse repetition interval (s)
Pt               = 1e3;                             % Transmitted power (W)
Gt_dBi           = 35;                              % Antenna peak gain (dBi)
noise_floor      = -111;                            % Noise floor (dBm)

N_Pulse          = 20;                              % Number of pulses in one CPI (slow time)
NFFT             = 256;                             % Doppler FFT size

% Derived values
PRF              = 1 / PRI;                         % Pulse repetition frequency (Hz)
lambda           = c / fc;                          % Wavelength (m)
k_lfm            = B / tau;                         % Chirp rate (Hz/s)
N_PRI            = fs * PRI;                        % Samples in one PRI (fast time, range axis)
N_Pulse_Sample   = fs * tau;                        % Samples in one pulse
t_p              = (0:N_Pulse_Sample - 1) / fs;     % Pulse time axis (s)
Gt_max           = 10^(Gt_dBi / 10);                % Antenna peak gain (linear)


%% 3. CFAR AND POST PROCESSING PARAMETERS
% -------------------------------------------------------------------------

num_ref          = 30;                              % Reference cells (half on the left, half on the right)
num_guard        = 6;                               % Guard cells (half on the left, half on the right)
k                = 20;                              % OS-CFAR: rank of the sorted reference cells that sets the threshold
threshold_factor = 8;                               % Threshold multiplier
peak_ratio       = 0.5;                             % Post processing: two neighbor peaks are 'different' below this power ratio
max_gap          = 15;                              % Post processing: peaks closer than this (range cells) are compared


%% 4. SCENARIOS
% -------------------------------------------------------------------------
% Only the scenario chosen in section 1 is used.

% --- 'simple': targets are given by range and velocity, all get the full antenna gain

p.Gt               = Gt_max;                        % Antenna gain (linear)
p.R_tgt            = [ 45e3, 55e3, 70e3, 80e3, 141e3];   % Ranges (m)
p.V_tgt            = [   15,  -15,    0,   10,    20];   % Radial velocities (m/s)
p.rcs_tgt          = [   10,   10,   10,   10,    10];   % Radar cross sections (m^2)

% --- 'lla': aircraft and targets are given by lat/lon/alt, the antenna pattern sets each target's gain

q.ac_lla           = [39.9,     32    10000];       % Aircraft [lat lon alt(m)]
q.ac_att           = [0,         0,       0];       % Aircraft attitude [roll pitch yaw] (deg)
q.ac_vel_ned       = [200,       0,       0];       % Aircraft velocity (NED), NOT USED by the chain

q.tgt_lla          = [40.35, 32.80, 10000;          % Targets [lat lon alt(m)]
                      39.90, 33.38, 10000;
                      40.35, 32.80,  5000;
                      40.28, 33.30, 10000;
                      40.10, 32.55,  9000];
q.tgt_vel_ned      = [-200,   0,        0;          % Target velocities (NED), NOT USED by the chain
                         0,   0,        0;
                         0,   0,        0];
q.V_radial         = [   15,  -15,    0,   10,    20];   % Radial velocities seen by the radar (m/s), USED
q.rcs_tgt          = [   10,   10,   10,   10,    10];   % Radar cross sections (m^2)

q.Gt               = Gt_dBi;                        % Antenna peak gain (dBi)
q.beam_az          = 53.510362710049975;            % Beam azimuth (deg)
q.beam_el          = 0.379702590858345;             % Beam elevation (deg, positive downward)
q.hpbw_az          = 6;                             % Half power beam width, azimuth (deg)
q.hpbw_el          = 20;                            % Half power beam width, elevation (deg)
q.floor_dB         = -50;                           % Side lobe floor of the antenna pattern (dB)


%% 5. SETUP
% -------------------------------------------------------------------------

if ~isempty(rng_seed), rng(rng_seed); end

% Noise and clutter amplitudes
noise_amp   = func_calculate_noise('noisefloor', noise_floor);
clutter_amp = 10 * noise_amp;

% Transmitted pulse (1 x N_Pulse_Sample, complex)
t_pulse = func_lfm_gen(k_lfm, t_p);                 % LFM
% t_pulse = func_param_barker_gen(13);              % Barker code (not tested with this chain)
% t_pulse = func_b_gen(7);                          % Random +-1 code (not tested with this chain)

% Targets: range, velocity, rcs and effective antenna gain of each target
switch scenario_mode
    case 'simple'
        [R, v, rcs, Gt_eff] = func_target_setup('simple', p);
    case 'lla'
        [R, v, rcs, Gt_eff] = func_target_setup('lla', q);
    otherwise
        error("scenario_mode must be 'simple' or 'lla'");
end


%% 6. RECEIVED SIGNAL
% -------------------------------------------------------------------------
% rx = targets + noise + clutter, size N_PRI x N_Pulse (fast time x slow time)

clutter = func_clutter_gen(t_pulse, N_PRI, N_Pulse, clutter_amp, PRF, lambda, c, fs);
rx      = func_get_received_signal(t_pulse, N_PRI, N_Pulse, R, v, rcs, Pt, Gt_eff, noise_amp);
rx      = rx + clutter;


%% 7. SIGNAL PROCESSING CHAIN
% -------------------------------------------------------------------------

% STEP 1: Window the pulse (Dolph-Chebyshev). It becomes the matched filter.
t_pulse_win = func_window_processing(t_pulse);

% STEP 2: Matched filter (fast time). Range compression.        N_PRI x N_Pulse
matched_output = func_matched(t_pulse_win, rx);

% STEP 3: MTI, three pulse canceller (slow time). Removes zero Doppler. N_PRI x (N_Pulse - 2)
mti_output = func_mti(matched_output);

% STEP 4: Doppler window and FFT (slow time).                   N_PRI x NFFT
windowed_output     = func_window_processing(mti_output);
windowed_fft_output = func_fft_processing(windowed_output, NFFT);

% STEP 5: OS-CFAR. Adaptive threshold for every range/Doppler cell. N_PRI x NFFT
[os_cfar_output, os_threshold_map] = func_os_cfar(windowed_fft_output, num_ref, num_guard, k, threshold_factor);

% STEP 6: Post processing. Range cells of the final detections.  1 x (number of detections)
detected_idx = func_cfar_post_processing(windowed_fft_output, os_threshold_map, peak_ratio, max_gap);


%% 8. RESULTS
% -------------------------------------------------------------------------

% Target table, Pd, Pfa, true and detected ranges
func_performance(windowed_fft_output, R, v, detected_idx, noise_amp, os_cfar_output, Gt_eff, Gt_max);

% Extra outputs that are only needed for the figures (not used for detection)
if plot_pipeline
    matched_fft_output = func_fft_processing(matched_output, NFFT);
    mti_fft_output     = func_fft_processing(mti_output, NFFT);
    ca_threshold_map   = func_ca_cfar(windowed_fft_output, num_ref, num_guard, threshold_factor);

    func_plot_pipeline(rx, matched_output, mti_output, matched_fft_output, windowed_output, windowed_fft_output, ...
                       mti_fft_output, os_cfar_output, os_threshold_map, ca_threshold_map, detected_idx, ...
                       PRF, lambda, fs, c, N_Pulse);
end

% Antenna pattern and 3D view (detected targets are green, the others are red)
if plot_scenario && strcmp(scenario_mode, 'lla')
    [~, ~, ~, ~, ~, ~, is_detected] = func_score_detections(detected_idx, R, v, Gt_eff, Gt_max);
    func_plot_beam_polar(q.hpbw_az, q.floor_dB);
    func_plot_lla(q.tgt_lla, q.ac_lla, q.beam_az, q.beam_el, q.ac_att, q.hpbw_az, q.hpbw_el, is_detected);
end


%% 9. MONTE CARLO (optional)
% -------------------------------------------------------------------------
% Repeats sections 6 and 7 with new noise and clutter. Targets and gains stay the same.
% The un-windowed pulse (t_pulse) is given, the function windows it once itself.

if run_monte_carlo
    tic
    func_monte_carlo(N_trials, num_ref, num_guard, threshold_factor, k, ...
                     t_pulse, R, v, rcs, Pt, Gt_eff, Gt_max, noise_amp, clutter_amp, ...
                     c, fs, N_PRI, N_Pulse, NFFT, peak_ratio, max_gap);
    toc
end


%% 10. FPGA TEST VECTORS (optional)
% -------------------------------------------------------------------------
% Quantizes rx to 16 bit and writes it with the expected output of every block
% to vectors/vec_<export_name>_nfft<export_NFFT>/ (see docs/FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md).

if export_vectors
    cfg = struct('fs', fs, 'fc', fc, 'PRI', PRI, 'tau', tau, 'B', B, 'N_PRI', N_PRI, 'N_Pulse', N_Pulse, ...
                 'NFFT', export_NFFT, 'num_ref', num_ref, 'num_guard', num_guard, 'k', k, ...
                 'threshold_factor', threshold_factor, 'peak_ratio', peak_ratio, 'max_gap', max_gap);
    scn = struct('name', export_name, 'seed', rng_seed, 'R', R, 'v', v, 'rcs', rcs, ...
                 'Gt_eff', Gt_eff, 'Gt_max', Gt_max);
    export_dir = fullfile(fileparts(mfilename('fullpath')), 'vectors', sprintf('vec_%s_nfft%d', export_name, export_NFFT));
    func_export_vectors(export_dir, rx, t_pulse, cfg, scn);
end
