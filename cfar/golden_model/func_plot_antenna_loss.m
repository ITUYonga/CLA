function func_plot_antenna_loss(x_interval, ang_az, loss_az, ang_el, loss_el)

 figure;
 plot(x_interval,func_antenna_loss(x_interval,ang_az,loss_az),'b', 'LineWidth',1.5)
 hold on;
 plot(x_interval,func_antenna_loss(x_interval,ang_el,loss_el),'r', 'LineWidth',1.5)
 legend('Azimuth', 'Elevation');
 xlabel('Boresight (degrees)');
 ylabel('Loss(dB)');
 ylim([0 40]);
 grid on;

end