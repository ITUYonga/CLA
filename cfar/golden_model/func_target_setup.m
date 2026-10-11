function [R, v, rcs, Gt_eff,az,el] = func_target_setup(mode,params)
%mode = 'simple'
%mode = 'lla'
%params : moda göre struct seçimi



switch mode
    case 'simple'
        R = params.R_tgt;
        v = params.V_tgt;
        rcs = params.rcs_tgt;
        Gt_eff = params.Gt * ones(1,length(R));

    case 'lla'
        [R,az,el] = func_geometry_engine(params.ac_lla,params.ac_att,...
                                           params.ac_vel_ned,...
                                           params.tgt_lla, params.tgt_vel_ned);
        rcs = params.rcs_tgt;
        v = params.V_radial;
        Gt_eff = func_effective_gain(params.Gt,az,el,...
                                     params.beam_az, params.beam_el,...
                                     params.hpbw_az, params.hpbw_el,...
                                     params.floor_dB);

        fprintf('Menzil(km): ');      fprintf('%.1f ', R/1e3);    fprintf('\n');
        fprintf('Azimuth(deg): ');    fprintf('%.1f ', az);       fprintf('\n');
        fprintf('Elevation(deg): ');  fprintf('%.1f ', el);       fprintf('\n');
        fprintf('Radial Velocity: '); fprintf('%.1f ', v); fprintf('\n');

    otherwise
        error("Invalid Mode Selection: 'simple' or 'lla' ");


end



end














% p.R_tgt            = [ 45e3, 55e3, 70e3, 80e3, 141e3]; % Range Array of Targets (m)
% p.V_tgt         = [ 15, -15, 0,  10,  20];            % Velocity Array of Targets (m/s)
% p.rcs_tgt          = [ 10, 10, 10,  10,  10];            % RCS(Radar Cross Section) Array of Targets (m^2)
% 
% 
% 
% q.ac_lla           = [39.9,     32    10000];
% q.ac_att           = [0,         0,       0];
% q.ac_vel_ned       = [200,       0,       0];
% 
% q.tgt_lla          = [40.35, 32.80, 10000;
%                     39.90, 33.38, 10000;
%                     40.35, 32.80,  5000];
% 
% q.tgt_vel_ned      = [-200,   0,        0;
%                        0,   0,        0;
%                        0,   0,        0];
% q.ang_az           = [ -8, -3,  0,   3,   8];
% q.loss_az          = [ 25,  3,  0,   3,  25];
% q.ang_el           = [-20, -10, 0,  10,  20];
% q.loss_el          = [ 20,   3, 0,   3,  20];
% q.x_interval       = -12 : 0.1 : 12;
% q.beam_az = 53.5;
% q.beam_el = 0.4;
% q.L_max = 70;
% q.V_radial         = [ 15, -15, 0,  10,  20];   
