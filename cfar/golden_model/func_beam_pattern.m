function gain_dB = func_beam_pattern(theta_deg,hpbw,floor_dB)
%FUNC_BEAM_PATTERN : Angle dependent antenna pattern (sinc^2 aperture)
%
%   Purpose:  Calculating the normalized antenna gain (dB) as a function of
%             the angle from the boresight. The pattern is 0 dB at the
%             boresight, -3 dB at hpbw/2 and drops to floor_dB in the
%             side lobe region.
%
%   inputs:
%             theta_deg:  Deviation from the boresight (degree)
%             hpbw:       Half power beam width (degree)
%             floor_dB:   Side lobe floor (dB), default is -50
%
%    output:
%             gain_dB:    Normalized antenna gain (dB), always <= 0

if nargin < 3, floor_dB = -50; end

% sinc(x) = sin(pi*x)/(pi*x) in MATLAB and sinc(x)^2 = 0.5 at x = 0.442946
% so Llam is chosen to make the pattern -3 dB at theta = hpbw/2
Llam = 0.442946/sind(hpbw/2);                 % aperture length (wavelength)
g = sinc(Llam * sind(theta_deg)) .^2;

gain_dB = max(10*log10(g + 1e-30),floor_dB);

end
