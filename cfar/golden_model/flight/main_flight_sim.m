%% MAIN_FLIGHT_SIM : Flight (moving) scenario driver, golden model
%
%   Purpose:  Straight and level flight, snake/raster scan, ardışık CPI'lar
%             (README.md section 14). Uses the same signal chain as
%             main_radar_sim.m but geometry and beam direction change every
%             CPI (func_kinematics, func_scan_pattern, func_flight_sim).
%             main_radar_sim.m is NOT touched, this is a separate entry
%             point so the existing single-frame scenarios keep working.
%
%   How to use:
%             1) Change the choices in section 1 (CPI count, seed, plots).
%             2) Change aircraft / target / scan values in sections 2-4.
%             3) Radar and CFAR parameters (section 5) are the SAME values
%                as main_radar_sim.m, do not change them here (hardware
%                size contract, see docs/FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md).
%             4) Press Run.

%% 0. WORKSPACE
% -------------------------------------------------------------------------

clear; close all; clc;
addpath(fullfile(fileparts(mfilename('fullpath')), '..'));   % golden_model/ (func_lfm_gen, func_matched, ...)


%% 1. USER SETTINGS
% -------------------------------------------------------------------------

n_cpi      = 250;         % Number of CPIs to run (250 * 20 ms = 5 s, about 1.5 scan cycles)
rng_seed   = 1;           % Same noise and clutter at every run. [] = different at every run
plot_scan  = true;        % Beam azimuth/elevation and detections over time


%% 2. AIRCRAFT
% -------------------------------------------------------------------------
% Straight and level flight, constant velocity, no maneuver (README.md section 14).

scn.ac_lla0    = [39.9, 32, 10000];     % Aircraft position at t = 0, [lat lon alt(m)]
scn.ac_att     = [0, 0, 0];             % Aircraft attitude [roll pitch yaw] (deg), constant
scn.ac_vel_ned = [200, 0, 0];           % Aircraft velocity (NED, m/s), constant


%% 3. TARGETS
% -------------------------------------------------------------------------
% Same 5 ground targets as the 'lla' scenario in main_radar_sim.m, all static
% (tgt_vel_ned = 0). Kept the same on purpose so results are comparable.

scn.tgt_lla = [40.35, 32.80, 10000;
               39.90, 33.38, 10000;
               40.35, 32.80,  5000;
               40.28, 33.30, 10000;
               40.10, 32.55,  9000];
scn.tgt_vel_ned = zeros(size(scn.tgt_lla));   % ground targets: static
scn.rcs_tgt      = [10, 10, 10, 10, 10];      % Radar cross sections (m^2)

scn.hpbw_az  = 6;                       % Half power beam width, azimuth (deg)
scn.hpbw_el  = 6;                       % Half power beam width, elevation (deg)
                                         % Pencil beam (not the 20 deg fan of the single-frame
                                         % scenario): with a 20 deg fan beam, 1-2 bars would
                                         % cover the whole elevation range and the scan would be
                                         % meaningless (README.md section 14, DEVLOG open question).
scn.floor_dB = -50;                     % Side lobe floor of the antenna pattern (dB)


%% 4. SCAN PATTERN
% -------------------------------------------------------------------------
% Snake / raster scan (func_scan_pattern). Sector is centered on the boresight
% of the single-frame 'lla' scenario so results stay comparable.

scan_cfg.az_center   = 53.510362710049975;   % Sector center azimuth (deg), same boresight as 'lla'
scan_cfg.az_width    = 60;                   % Sector width (deg)
scan_cfg.az_rate_dps = 60;                   % Azimuth sweep rate (deg/s): 1 s to cross the sector
scan_cfg.el_top      = 0.379702590858345;    % Elevation of the top bar (deg), same as 'lla' boresight
scan_cfg.el_step     = scn.hpbw_el;          % Elevation step between bars (deg)
scan_cfg.n_bars      = 3;                    % Number of bars, wraps back to the top after this many


%% 5. RADAR AND CFAR PARAMETERS
% -------------------------------------------------------------------------
% SAME values as main_radar_sim.m sections 2-3. Do not change without also
% updating main_radar_sim.m and the FPGA vectors (hardware size contract).

radar_cfg.fs          = 1e6;      % Sampling rate (Hz)
radar_cfg.fc          = 3e9;      % Operating frequency (Hz)
radar_cfg.c            = 3e8;     % Speed of light in free space (m/s)
radar_cfg.tau          = 20e-6;   % Pulse width (s)
radar_cfg.B            = 400e3;   % Bandwidth of the LFM pulse (Hz)
radar_cfg.PRI          = 1e-3;    % Pulse repetition interval (s)
radar_cfg.Pt           = 1e3;     % Transmitted power (W)
radar_cfg.Gt_dBi       = 35;      % Antenna peak gain (dBi)
radar_cfg.noise_floor  = -111;    % Noise floor (dBm)
radar_cfg.N_Pulse      = 20;      % Number of pulses in one CPI (slow time)
radar_cfg.NFFT         = 256;     % Doppler FFT size

cfar_cfg.num_ref          = 30;   % Reference cells (half on the left, half on the right)
cfar_cfg.num_guard        = 6;    % Guard cells (half on the left, half on the right)
cfar_cfg.k                = 20;   % OS-CFAR: rank of the sorted reference cells that sets the threshold
cfar_cfg.threshold_factor = 8;    % Threshold multiplier
cfar_cfg.peak_ratio       = 0.5;  % Post processing: two neighbor peaks are 'different' below this ratio
cfar_cfg.max_gap          = 15;   % Post processing: peaks closer than this (range cells) are compared


%% 6. RUN
% -------------------------------------------------------------------------

tic
log = func_flight_sim(scn, radar_cfg, cfar_cfg, scan_cfg, n_cpi, rng_seed);
elapsed = toc;
fprintf('%d CPI, %.1f s (%.0f ms/CPI, CPI itself is %.0f ms of simulated time)\n', ...
        n_cpi, elapsed, 1000*elapsed/n_cpi, 1000*radar_cfg.N_Pulse*radar_cfg.PRI);


%% 7. RESULTS
% -------------------------------------------------------------------------
% Summary: how many CPIs had a valid target in the beam, and how many of
% those were detected (same rule as func_score_detections, applied per CPI
% by func_flight_sim and summed here).

n_cpi_with_valid  = sum(log.n_valid > 0);
n_cpi_with_hit    = sum(log.hits > 0);
total_valid       = sum(log.n_valid);
total_hits        = sum(log.hits);
total_false_alarm = sum(log.false_alarms);

fprintf('CPIs with a valid (moving, in beam) target: %d / %d\n', n_cpi_with_valid, n_cpi);
fprintf('Of those, detected: %d / %d\n', n_cpi_with_hit, n_cpi_with_valid);
fprintf('Total valid-target-CPIs: %d, hits: %d (Pd = %.2f)\n', total_valid, total_hits, total_hits/max(total_valid,1));
fprintf('Total false alarms: %d (%.3f / CPI)\n', total_false_alarm, total_false_alarm/n_cpi);

if plot_scan
    figure('Name', 'Flight scenario: scan and detections');

    subplot(2,1,1);
    plot(log.t, log.beam_az, 'b-'); hold on;
    yline(scan_cfg.az_center, 'k--');
    plot(log.t(log.hits>0), log.beam_az(log.hits>0), 'g.', 'MarkerSize', 14);
    xlabel('t (s)'); ylabel('beam az (deg)');
    title('Beam azimuth (green dot = a valid target was detected this CPI)');
    grid on;

    subplot(2,1,2);
    plot(log.t, log.beam_el, 'b-'); hold on;
    plot(log.t(log.hits>0), log.beam_el(log.hits>0), 'g.', 'MarkerSize', 14);
    xlabel('t (s)'); ylabel('beam el (deg)');
    title('Beam elevation (bar steps)');
    grid on;
end
