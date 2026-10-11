function func_plot_pipeline(rx, matched_output, mti_output, matched_fft_output, windowed_output, windowed_fft_output, mti_fft_output, os_cfar_output, os_threshold_map, ca_threshold_map, detected_idx, PRF, lambda, fs, c ,N_Pulse)
%FUNC_PLOT_PIPELINE : Plots all the desired signals
%Can Ertürk
%
%   Purpose:  Plotting each desired signal in the end-to-end article. All
%             the plotting code blocks are stored in this pipeline
%             function.
%            
%   inputs:
%
%             rx:                    Received Signal with clutter and noise
%
%             matched_output:        The signal after passed through match
%                                    filter
%
%             mti_output:            The signal after passed through mti
%                                    filter
%
%             matched_fft_output:    The matched signal after passed
%                                    through fft
%
%             windowed_output:       The signal after passed 
%                                    through windowing operation
%
%             windowed_fft_output:   The windowed signal after passed
%                                    through fft
%
%             mti_fft_output:        The mti applied signal after passed
%                                    through fft
%
%             os_cfar_output:        The signal output after passed
%                                    through the os_cfar operation
%
%             os_threshold_map:      The updated result of threshold_map matrix
%
%             PRF:                   Pulse Repetition Frequency
%             lambda:                The wavelength (m)
%             fs:                    Sampling Frequency (1/s)
%             c:                     Speed of Light (m/s)
%             N_pulse:               Number of Transmitted Pulses
%
%    output: 
%             func_plot_pipeline:    it is not an output, plotting operation 

 


%RECEIVED SIGNAL (BEFORE MATCHED FILTER)

    range_km = (0:size(rx,1)-1) * c/(2*fs)/ 1e3;
    pulses = 1: size(rx,2);
    figure;
    surf(pulses,range_km,20*log10(abs(rx)+ eps));
    shading flat;
    colormap jet;
    xlabel('Pulse Number');
    ylabel('Range(km)');
    zlabel('Magnitude (dB)');
    title('Received Signal (Before Matched Filter)');
    

    % MATCH FILTER OUTPUT

    range_km = (0:size(matched_output,1) - 1) * c/(2*fs)/ 1e3;
    v_axis = linspace(-PRF/2, PRF/2,size(matched_fft_output,2)) * lambda/2;

    
    figure;
    surf(1:N_Pulse,range_km,20*log10(abs(matched_output)));
    shading flat;
    colormap turbo;
    xlabel('Pulse Number');
    ylabel('range(km)');
    zlabel('dB');
    title('Match Filter Output');
    view(45,30);   

    % MATCHED FFT OUTPUT

    figure;
    surf(v_axis, range_km, 20*log10(abs(matched_fft_output)));
    shading flat;
    colormap jet;
    xlabel('Speed(m/s)');
    ylabel('Range(km)');
    zlabel('dB');
    title('Matched FFT')
    view(45,30);

    % MTI FFT OUTPUT

    range_km = (0:size(mti_output,1) - 1) * c/(2*fs)/ 1e3;
    v_axis = linspace(-PRF/2, PRF/2,size(mti_fft_output,2)) * lambda/2;

    figure;
    surf(v_axis, range_km, 20*log10(abs(mti_fft_output)));
    shading flat;
    colormap jet;
    xlabel('Speed(m/s)');
    ylabel('Range(km)');
    zlabel('dB');
    title('MTI FFT')
    view(45,30);

    % WINDOWED FFT OUTPUT

    range_km = (0:size(windowed_output,1) - 1) * c/(2*fs)/ 1e3;
    v_axis = linspace(-PRF/2, PRF/2,size(windowed_fft_output,2)) * lambda/2;
    
    figure;
    surf(v_axis, range_km, 20*log10(abs(windowed_fft_output)));
    shading flat;
    colormap jet;
    xlabel('Speed(m/s)');
    ylabel('Range(km)');
    zlabel('dB');
    title('Windowed FFT')
    view(45,30);


    figure;


    % 2D MATCH FILTER OUTPUT

    subplot(3,1,1)
    plot(range_km, 20* log10(abs(matched_output(:,1))))
    xlabel('Range(km)');
    ylabel('dB');
    title('Matched Filter');
    grid on;

    % 2D MTI OUTPUT

    subplot(3,1,2)
    plot(range_km, 20*log10(abs(mti_output(:,1))));
    xlabel('Range(km)');
    ylabel('dB');
    title('MTI OUTPUT');
    grid on;

    % MATCHED FFT OUTPUT

    subplot(3,1,3)
    surf(v_axis, range_km, 20*log10(abs(mti_fft_output)));
    shading flat;
    colormap jet;
    xlabel('Speed(m/s)')
    ylabel('Range(km)');
    zlabel('dB');
    title('MTI FFT')
    view(45,30);


    % CFAR OUTPUT

    range_km = (0:size(os_cfar_output,1) - 1) * c/(2 * fs)/ 1e3;
    detection = max(os_cfar_output, [], 2);

    power_fast_time = abs(windowed_fft_output).^2;
    input_max = max(power_fast_time,[],2);
    threshold_max = max(os_threshold_map, [],2);
    ca_threshold_max = max(ca_threshold_map, [],2);


    figure;
    hold on;
    plot(range_km, 10*log10(input_max + eps), 'b','LineWidth' ,1.2);
    plot(range_km, 10*log10(threshold_max + eps),'r', 'LineWidth' ,1.2);
    plot(range_km, 10*log10(threshold_max*1.5 + eps),'y', 'LineWidth' ,1.2);
    plot(range_km, 10*log10(ca_threshold_max + eps),'m', 'LineWidth' ,1.2);

    ymin = min(10*log10(threshold_max + eps));
    ymax = max(10*log10(input_max + eps));


    for m = 1 : length(detected_idx)
        x = range_km(detected_idx(m));
        plot([x x], [ymin ymax], 'g--', 'LineWidth',1.2);
    end

    legend('Input Fast-time Data', 'CFAR Threshold', 'CFAR with Margin', 'CA-CFAR THRESHOLD','Detection' );
    xlabel('Range(km)');
    ylabel('Magnitude(dB)');
    grid on;
    title('CFAR OUTPUT');
   



end