function [R, az, el, v_radial, ac_pos_ned, d_ned] = func_kinematics(t, ac_lla0, ac_att, ac_vel_ned, tgt_lla, tgt_vel_ned)
%FUNC_KINEMATICS : Aircraft and target geometry as a function of time
%Can Ertürk
%
%   Purpose:  Straight and level flight kinematics for the flight scenario
%             (see README.md section 14). The aircraft flies with constant
%             NED velocity starting from ac_lla0 (no maneuver, attitude is
%             fixed). Targets are given in LLA and are static on the ground
%             by default (tgt_vel_ned = 0), but a constant NED velocity can
%             be given if needed.
%
%             Range/azimuth/elevation use the same LLA -> ECEF -> NED -> BODY
%             chain and the same convention as func_geometry_engine (az
%             positive right, el positive downward). The target's NED
%             position relative to ac_lla0 is computed once per call with
%             func_lla2ned_custom (same as func_geometry_engine); the
%             aircraft's own motion is then added as a flat-earth NED
%             displacement (ac_vel_ned * t), which avoids converting the
%             aircraft's position back to LLA at every CPI. This is a good
%             approximation for the flight distances of one scenario run
%             (tens of km), not for long-range navigation.
%
%             Radial velocity is the closing rate along the line of sight
%             (target minus aircraft velocity, projected on the line of
%             sight, sign flipped so a positive value means the aircraft is
%             closing in on the target). This was a commented out, unused
%             formula in func_geometry_engine; it is used here for real
%             because the flight scenario cannot set it by hand.
%
%   inputs:
%             t:            Time since t = 0 (s), scalar
%             ac_lla0:      Aircraft position at t = 0, [lat lon alt] (deg,deg,m)
%             ac_att:       Aircraft attitude [roll pitch yaw] (deg), constant
%             ac_vel_ned:   Aircraft velocity [Vn Ve Vd] (m/s), constant
%             tgt_lla:      Target positions, Nx3 [lat lon alt] (deg,deg,m)
%             tgt_vel_ned:  (optional) Target velocities, Nx3 (m/s). Default: 0 (ground targets)
%
%    outputs:
%             R:            Range of each target (m)
%             az, el:       Azimuth and elevation in body frame (deg)
%             v_radial:     Radial (closing) velocity of each target (m/s), positive = closing
%             ac_pos_ned:   Aircraft position relative to ac_lla0, NED (m) [1x3]
%             d_ned:        Target position relative to the aircraft, NED (m) [Nx3]

if nargin < 6 || isempty(tgt_vel_ned)
    tgt_vel_ned = zeros(size(tgt_lla));
end

N        = size(tgt_lla, 1);
R        = zeros(1, N);
az       = zeros(1, N);
el       = zeros(1, N);
v_radial = zeros(1, N);
d_ned    = zeros(N, 3);

% Aircraft position relative to ac_lla0 (flat-earth NED displacement)
ac_pos_ned = ac_vel_ned(:)' * t;

% NED to body rotation matrix (constant, no maneuver)
c_ned2body = angle2dcm(deg2rad(ac_att(3)), deg2rad(ac_att(2)), deg2rad(ac_att(1)));

for i = 1:N
    % Target position relative to ac_lla0 (same helper as func_geometry_engine)
    tgt_pos_ned0 = func_lla2ned_custom(tgt_lla(i,:), ac_lla0);

    % Target position relative to the aircraft's CURRENT position
    d_ned(i,:) = tgt_pos_ned0(:)' - ac_pos_ned;

    d_body = c_ned2body * d_ned(i,:)';

    R(i)  = norm(d_body);
    az(i) = atan2d(d_body(2), d_body(1));
    el(i) = atan2d(d_body(3), sqrt(d_body(1)^2 + d_body(2)^2));

    v_rel = tgt_vel_ned(i,:) - ac_vel_ned;
    los   = d_ned(i,:) / norm(d_ned(i,:));
    v_radial(i) = -dot(v_rel, los);
end

end
