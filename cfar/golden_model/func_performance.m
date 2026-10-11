function Pd = func_performance(fft_output, R_tgt,V_tgt, detected_idx,noise_amp,os_cfar_output,Gt_eff,Gt_max)
%FUNC_PERFORMANCE : Calculates performance metrics about os_cfar
%Can Ertürk
%
%   Purpose:  Calculating Probability Detection(Pd) and Probability of False
%             Alarm (Pfa) rates in one scenerio.
%             Pd is calculated over the targets that the beam illuminates
%             (target gain is at most 3 dB lower than the boresight gain)
%             and moving (v ~= 0, because MTI cancels the static ones).
%             A target table is printed to see each target separately.
%
%   inputs:
%             fft_output:     Resulting signal from windowing and fft
%             R_tgt:          Target distances (m)
%             V_tgt:          Target velocities (m/s)
%             detected_idx:   Distance indexes of the 'detected' targets
%             noise_amp:      Applied noise constant to make more realistic both phase and real
%                             part of the signal
%
%             os_cfar_output: Resulting os_cfar_output.
%             Gt_eff:         (optional) Effective gain of each target (linear)
%             Gt_max:         (optional) Gain at the boresight (linear)
%                             if they are not given, all targets are illuminated
%
%    output:
%             prints target table, calculated snr values,
%             pd and pfa for one trial scenerio,
%             distances of real and detected targets for comparison.
%             Pd:             Probability of detection of illuminated targets

        c = 3e8;
        fs = 1e6;

        % Every target is listed, valid ones (moving and illuminated) are used for Pd
        % Counting rules are in func_score_detections (same as func_monte_carlo)
        non_static = V_tgt ~=0;

        if nargin < 8
            [hits,n_valid,false_alarms,target_idx,valid,pattern_dB] = func_score_detections(detected_idx,R_tgt,V_tgt);
        else
            [hits,n_valid,false_alarms,target_idx,valid,pattern_dB] = func_score_detections(detected_idx,R_tgt,V_tgt,Gt_eff,Gt_max);
        end

        %num_cells: total range cells
        num_cells = size(os_cfar_output ,1);

        range_km = (0 : size(fft_output , 1) - 1) * c /(2 * fs) / 1e3;
        power_signal = abs(fft_output).^2;
        tol = 5;



        % TARGET TABLE (SNR + detection status of each target)

        fprintf('\n %-3s %8s %10s %8s %10s %9s\n','No','R (km)','Pattern','Moving','SNR (dB)','Detected');
        for h = 1 : length(target_idx)
            sig = max(power_signal(target_idx(h), :));
            snr = 10 * log10(sig/noise_amp^2);
            if valid(h)
                status = yesno(any(abs(detected_idx - target_idx(h)) <= tol));
            else
                status = '-';                     % not expected to be seen
            end
            fprintf(' %-3d %8.1f %8.1f dB %8s %10.2f %9s\n', h, R_tgt(h)/1e3, pattern_dB(h), ...
                    yesno(non_static(h)), snr, status);
        end



        % Pd Calculation (only for the valid targets)

        Pd = hits / n_valid;
        fprintf('\nPd = %.2f (%d / %d illuminated moving targets)\n' , Pd, hits, n_valid);




        %Pfa Calculation (false alarms: detections that are not near to any valid target)



        Pfa = false_alarms / num_cells;
        fprintf('Pfa = %.2e\n', Pfa);
        fprintf('True Targets (km) : ');
        fprintf(' %.1f ', range_km(target_idx(valid)));
        fprintf('\n');



        fprintf('Detected targets (km) : ');
        fprintf('  %.1f', range_km(detected_idx));
        fprintf('\n\n');


end

function s = yesno(x)
% Prints 'yes' or 'no' for the target table
    if x, s = 'yes'; else, s = 'no'; end
end
