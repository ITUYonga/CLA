function Gt_eff = func_effective_gain(Gt_max_dB,az,el,beam_az,beam_el,hpbw_az,hpbw_el,floor_dB)
%FUNC_EFFECTIVE_GAIN : Transmit antenna gain as a function of azimuth and elevation
%
%   Purpose:  Calculating the effective antenna gain of each target by using
%             its angles (body frame) and the direction that the antenna
%             looks at. Azimuth and elevation patterns (sinc^2) are
%             calculated separately and summed in dB.
%             Gain is the maximum (Gt_max_dB) at the boresight, 3 dB less
%             at the half of the beam width and goes down to the floor
%             outside of the beam.
%
%   inputs:
%             Gt_max_dB:      Antenna gain at the boresight (dBi)
%             az, el:         Angles of the targets in body frame (degree)
%             beam_az/el:     The direction that the antenna looks at (degree)
%             hpbw_az/el:     Half power beam width of azimuth and elevation (degree)
%             floor_dB:       Side lobe floor (dB), default is -50
%
%    output:
%             Gt_eff:         Effective gain of each target (linear, not dB)

if nargin < 8, floor_dB = -50; end

% Deviation from the beam, azimuth is wrapped to [-180,180] (170 and -170 are 20 degree apart)
d_az = mod(az - beam_az + 180, 360) - 180;
d_el = el - beam_el;

L_az = func_beam_pattern(d_az,hpbw_az,floor_dB);
L_el = func_beam_pattern(d_el,hpbw_el,floor_dB);

pattern_dB = max(L_az + L_el, floor_dB);
Gt_eff = 10.^((Gt_max_dB + pattern_dB)/10);

end
