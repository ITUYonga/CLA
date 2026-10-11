function [beam_az, beam_el, bar_idx] = func_scan_pattern(t, az_center, az_width, az_rate_dps, el_top, el_step, n_bars)
%FUNC_SCAN_PATTERN : Snake (raster) scan pattern, mechanical radar style
%Can Ertürk
%
%   Purpose:  Gives the antenna boresight direction (beam_az, beam_el) as a
%             function of time for a snake / raster scan (see README.md
%             section 14): azimuth sweeps back and forth across a sector at
%             a constant angular rate; every time it reaches a sector edge,
%             elevation steps down by one bar and azimuth reverses
%             direction. After the last bar, elevation returns to the top
%             bar (the azimuth direction keeps alternating, it is not
%             reset). Bars are numbered 0 (top) to n_bars-1 (bottom).
%
%             Simplification: elevation changes instantly between bars, no
%             retrace time is modeled (this is a golden model, not a servo
%             simulation).
%
%   inputs:
%             t:            Time since the scan started (s), scalar
%             az_center:    Center azimuth of the sector (deg)
%             az_width:     Total width of the sector (deg), sweep goes from
%                           az_center - az_width/2 to az_center + az_width/2
%             az_rate_dps:  Azimuth sweep rate (deg/s)
%             el_top:       Elevation of the first (top) bar (deg, positive downward)
%             el_step:      Elevation step between bars (deg)
%             n_bars:       Number of bars before the scan returns to the top
%
%    outputs:
%             beam_az:      Current azimuth of the boresight (deg)
%             beam_el:      Current elevation of the boresight (deg)
%             bar_idx:      Current bar (0 based, 0 = top)

leg_dur = az_width / az_rate_dps;      % time to sweep across the sector once, one direction
leg_idx = floor(t / leg_dur);
t_in_leg = t - leg_idx * leg_dur;

% Direction alternates every leg (0 = left to right, 1 = right to left)
going_right = mod(leg_idx, 2) == 0;

az_left  = az_center - az_width/2;
az_right = az_center + az_width/2;

if going_right
    beam_az = az_left + az_rate_dps * t_in_leg;
else
    beam_az = az_right - az_rate_dps * t_in_leg;
end

bar_idx = mod(leg_idx, n_bars);
beam_el = el_top + bar_idx * el_step;

end
