function func_resolution_test(sep_list,power_diff_dB,N_trials,pulse,R_first,Pt,Gt,noise_amp,clutter_amp,...
                              num_ref,num_guard,k,threshold_factor,peak_ratio,max_gap)
%FUNC_RESOLUTION_TEST : Range resolution test with two close targets
%Can Ertürk
%
%   Purpose:  Placing two targets with the same velocity at R_first and
%             R_first + separation, and checking whether they are still
%             seen as two separate targets after each step:
%
%             1) Matched filter : two peaks with a dip (>= 3 dB) between them
%                                 (limit of the waveform, bandwidth and window)
%             2) OS-CFAR        : both targets cross the threshold
%                                 (limit of the masking, not meaningful when
%                                 the separation is less than 3 cells)
%             3) Post-processing: two separate detections are left
%                                 (limit of max_gap and peak_ratio)
%
%             The second target is weaker than the first one by power_diff_dB.
%             Clutter and noise are generated again at each trial.
%
%   inputs:
%             sep_list:       Separations between two targets (m)
%             power_diff_dB:  Power difference of the two targets (dB)
%             N_trials:       Number of trials for each separation
%             pulse:          Transmitted signal (not windowed)
%             R_first:        Range of the first target (m)
%             Pt, Gt:         Transmitted power (W) and antenna gain (linear)
%             noise_amp:      Noise constant
%             clutter_amp:    Clutter constant
%             num_ref, num_guard, k, threshold_factor, peak_ratio, max_gap:
%                             CFAR and post-processing parameters
%
%    output:
%             prints the percentage of the trials in which the targets
%             are separated for each step

        c = 3e8;
        fs = 1e6;
        fc = 3e9;
        PRF = 1e3;
        lambda = c / fc;
        N_PRI = 1000;
        N_Pulse = 20;
        NFFT = 256;
        V = [15, 15];                            % same velocity: only range differs
        rcs = [10, 10 * 10^(-power_diff_dB/10)];
        tol = 1;                                 % cell tolerance to match a detection to a target
        crop = 100;                              % range cells around the targets that CFAR works on (speed)

        pulse_w = func_window_processing(pulse);

        fprintf('\nPower difference: %g dB, %d trials for each separation\n',power_diff_dB,N_trials);
        fprintf(' %9s %7s %12s %8s %14s\n','Sep (m)','Cells','MatchedF (%)','CFAR (%)','PostProc (%)');

        for s = 1:length(sep_list)
            R = [R_first, R_first + sep_list(s)];
            idx = round(2*R/c*fs) + 1;           % cells of the targets after matched filter
            r1 = max(idx(1) - crop, 1);
            r2 = min(idx(2) + crop, N_PRI);
            ok_mf = 0; ok_cfar = 0; ok_post = 0;

            for trial = 1:N_trials
                clutter = func_clutter_gen(pulse,N_PRI,N_Pulse,clutter_amp,PRF,lambda,c,fs);
                rx = func_get_received_signal(pulse,N_PRI,N_Pulse,R,V,rcs,Pt,Gt*ones(1,2),noise_amp);
                rx = rx + clutter;

                mo = func_matched(pulse_w,rx);
                mti = func_mti(mo);
                F = func_fft_processing(func_window_processing(mti),NFFT);

                % 1) Matched filter : the dip between two peaks (first pulse envelope)
                env = abs(mo(:,1));
                p1 = max(env(idx(1)-1 : idx(1)+1));
                p2 = max(env(idx(2)-1 : idx(2)+1));
                if idx(2) - idx(1) >= 2
                    dip = min(env(idx(1)+1 : idx(2)-1));
                    ok_mf = ok_mf + (dip <= 0.708 * min(p1,p2));     % 3 dB in amplitude
                end

                % 2) OS-CFAR : cropped range cells to make the test faster
                [out,thr] = func_os_cfar(F(r1:r2,:),num_ref,num_guard,k,threshold_factor);
                hit1 = any(any(out(idx(1)-r1+1 + (-tol:tol), :)));
                hit2 = any(any(out(idx(2)-r1+1 + (-tol:tol), :)));
                ok_cfar = ok_cfar + (hit1 && hit2);

                % 3) Post-processing : two different detections, one for each target
                det = func_cfar_post_processing(F(r1:r2,:),thr,peak_ratio,max_gap) + r1 - 1;
                d1 = find(abs(det - idx(1)) <= tol);
                d2 = find(abs(det - idx(2)) <= tol);
                if ~isempty(d1) && ~isempty(d2) && ~isequal(d1(1),d2(1))
                    ok_post = ok_post + 1;
                end
            end

            fprintf(' %9.0f %7.1f %12.0f %8.0f %14.0f\n', sep_list(s), sep_list(s)/(c/(2*fs)), ...
                    100*ok_mf/N_trials, 100*ok_cfar/N_trials, 100*ok_post/N_trials);
        end
        fprintf('\n');
end
