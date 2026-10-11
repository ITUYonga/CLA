function func_plot_lla(tgt_lla, ac_lla, beam_az, beam_el, ac_att, hpbw_az, hpbw_el, is_detected)
%FUNC_PLOT_LLA : 3D view of the aircraft, targets and the beam (NED)
%
%   Purpose:  Plotting the aircraft (origin), the targets and the half power
%             (-3 dB) contour of the antenna beam. The beam is an elliptic
%             cone because azimuth and elevation beam widths are different.
%             Detected targets are green, the others are red.
%
%   inputs:
%             tgt_lla:      LLA of the targets
%             ac_lla:       LLA of the aircraft (origin of the plot)
%             beam_az/el:   The direction that the antenna looks at (degree)
%                           elevation is positive downward (geometry engine)
%             ac_att:       Aircraft attitudes [roll pitch yaw] (degree)
%             hpbw_az/el:   Half power beam widths (degree)
%             is_detected:  (optional) Logical array, detected targets are green,
%                           the others are red

 if nargin < 8, is_detected = false(1,size(tgt_lla,1)); end

 figure; hold on; grid on;

 plot3(0,0,0,'k^','MarkerSize',14,'MarkerFaceColor','k',Color= 'green');

 for i = 1:size(tgt_lla,1)
     d = func_lla2ned_custom(tgt_lla(i,:),ac_lla);
     if is_detected(i), color = 'g'; else, color = 'r'; end
     plot3(d(1),d(2),d(3),'o','Color',color,'MarkerSize',10,'MarkerFaceColor',color);
     text(d(1),d(2),d(3),sprintf('  T%d',i));
 end
 % Legend entries (empty points, only for the colors)
 h_det = plot3(nan,nan,nan,'o','Color','g','MarkerFaceColor','g');
 h_und = plot3(nan,nan,nan,'o','Color','r','MarkerFaceColor','r');

 % Beam : boresight line and the half power contour (ellipse) on the cone
 % func_bodyangles2ned takes upward positive elevation, geometry engine is downward positive
 roll = deg2rad(ac_att(1)); pitch = deg2rad(ac_att(2)); yaw = deg2rad(ac_att(3));

 phi = linspace(0,2*pi,73);                    % points of the ellipse
 ring = zeros(3,length(phi));
 for m = 1:length(phi)
     az_m = beam_az + hpbw_az/2 * cos(phi(m));
     el_m = beam_el + hpbw_el/2 * sin(phi(m));
     ring(:,m) = func_bodyangles2ned(deg2rad(az_m),-deg2rad(el_m),roll,pitch,yaw);
 end

 center = func_bodyangles2ned(deg2rad(beam_az),-deg2rad(beam_el),roll,pitch,yaw);
 plot3([0 center(1)],[0 center(2)],[0 center(3)],'c--','LineWidth',1);

 plot3(ring(1,:),ring(2,:),ring(3,:),'c-','LineWidth',2);
 for m = 1:9:length(phi)-1                     % 8 edge lines from the aircraft to the ellipse
     plot3([0 ring(1,m)],[0 ring(2,m)],[0 ring(3,m)],'c-','LineWidth',1);
 end

 legend([h_det h_und],{'Detected','Not detected'},'Location','best');
 xlabel('N');
 ylabel('E');
 zlabel('D');
 axis equal;
 view(45,25);
 set(gca,'ZDir','reverse');

end
