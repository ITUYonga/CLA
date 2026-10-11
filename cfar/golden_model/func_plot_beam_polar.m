function func_plot_beam_polar(hpbw,floor_dB)


if nargin <2, floor_dB = -50; end
theta = linspace(-180,180,4000);
g = func_beam_pattern(theta,hpbw,floor_dB);

g(abs(theta) > 90) = floor_dB;
rmax = abs(floor_dB);
figure('Color','w');
polarplot(deg2rad(theta),g-floor_dB,'LineWidth',1.3);
ax = gca;


ax.ThetaZeroLocation = 'top';
ax.ThetaDir          = 'clockwise';
rlim([0 ,rmax]);
rticks(0:10: -floor_dB);
rticklabels(string(floor_dB : 10 : 0));
title(sprintf('Antenna Patern (HPBW = %g)',hpbw));




end