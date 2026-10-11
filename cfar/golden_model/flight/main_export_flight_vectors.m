%% MAIN_EXPORT_FLIGHT_VECTORS : Long, many-CPI FPGA test vector set (flight scenario)
%
%   Purpose:  Runs the flight scenario for a long, fixed duration and writes
%             a lightweight CPI-sequence vector set for FPGA testing
%             (continuous stream / timing, not block-by-block debugging --
%             see func_export_flight_vectors.m header and
%             docs/FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md section 10).
%
%             Same aircraft/target/scan setup as main_flight_sim.m, only
%             NFFT is 128 here (matches the RTL, main_flight_sim.m's default
%             256 is for the plotting-oriented exploration run).

clear; close all; clc;
addpath(fullfile(fileparts(mfilename('fullpath')), '..'));   % golden_model/ (func_lfm_gen, func_matched, ...)

%% 1. SETTINGS
% -------------------------------------------------------------------------

duration_s = 40;          % Total scenario duration (s)
rng_seed   = 1;           % Same noise and clutter at every run. [] = different at every run
export_name = 'flight_40s';


%% 2. AIRCRAFT, TARGETS, SCAN (same as main_flight_sim.m)
% -------------------------------------------------------------------------

scn.ac_lla0    = [39.9, 32, 10000];
scn.ac_att     = [0, 0, 0];
scn.ac_vel_ned = [200, 0, 0];

scn.tgt_lla = [40.35, 32.80, 10000;
               39.90, 33.38, 10000;
               40.35, 32.80,  5000;
               40.28, 33.30, 10000;
               40.10, 32.55,  9000];
scn.tgt_vel_ned = zeros(size(scn.tgt_lla));
scn.rcs_tgt      = [10, 10, 10, 10, 10];

scn.hpbw_az  = 6;
scn.hpbw_el  = 6;
scn.floor_dB = -50;

scan_cfg.az_center   = 53.510362710049975;
scan_cfg.az_width    = 60;
scan_cfg.az_rate_dps = 60;
scan_cfg.el_top      = 0.379702590858345;
scan_cfg.el_step     = scn.hpbw_el;
scan_cfg.n_bars      = 3;


%% 3. RADAR AND CFAR PARAMETERS
% -------------------------------------------------------------------------
% Same values as main_radar_sim.m / main_flight_sim.m, EXCEPT NFFT = 128
% (matches the RTL FFT_POINT, same reason vec_nominal_nfft128 uses 128
% instead of the plotting default of 256).

radar_cfg.fs          = 1e6;
radar_cfg.fc          = 3e9;
radar_cfg.c           = 3e8;
radar_cfg.tau         = 20e-6;
radar_cfg.B           = 400e3;
radar_cfg.PRI         = 1e-3;
radar_cfg.Pt          = 1e3;
radar_cfg.Gt_dBi      = 35;
radar_cfg.noise_floor = -111;
radar_cfg.N_Pulse     = 20;
radar_cfg.NFFT        = 128;

cfar_cfg.num_ref          = 30;
cfar_cfg.num_guard        = 6;
cfar_cfg.k                = 20;
cfar_cfg.threshold_factor = 8;
cfar_cfg.peak_ratio       = 0.5;
cfar_cfg.max_gap          = 15;

n_cpi = round(duration_s / (radar_cfg.N_Pulse * radar_cfg.PRI));


%% 4. RUN AND WRITE
% -------------------------------------------------------------------------

golden_model_dir = fileparts(fileparts(mfilename('fullpath')));   % golden_model/ (this file is one level down, in flight/)
out_dir = fullfile(golden_model_dir, 'vectors', sprintf('vec_%s_nfft%d', export_name, radar_cfg.NFFT));

fprintf('Writing %d CPIs (%.1f s of simulated flight) to %s\n', n_cpi, n_cpi * radar_cfg.N_Pulse * radar_cfg.PRI, out_dir);
tic
log = func_export_flight_vectors(out_dir, scn, radar_cfg, cfar_cfg, scan_cfg, n_cpi, rng_seed, export_name);
elapsed = toc;

fprintf('Done in %.1f s (%.0f ms/CPI)\n', elapsed, 1000*elapsed/n_cpi);
fprintf('CPIs with a valid (moving, in beam) target: %d / %d\n', sum(log.n_valid > 0), n_cpi);
fprintf('Total valid-target-CPIs: %d, hits: %d (Pd = %.2f)\n', sum(log.n_valid), sum(log.hits), sum(log.hits)/max(sum(log.n_valid),1));
fprintf('Total false alarms: %d (%.3f / CPI)\n', sum(log.false_alarms), sum(log.false_alarms)/n_cpi);
fprintf('Saturated rx samples (any CPI): %d\n', sum(log.n_sat_rx));
