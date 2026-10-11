function clutter = func_clutter_gen(t_pulse,N_pri,N_pulses,clutter_amp,PRF,lambda,c,fs)
%FUNC_CLUTTER_GEN : Generates a Simple, Decreasing Clutter
%Can Ertürk
%
%   Purpose:  For generating a exponentially decreasing, constant
%             amplification coefficient data to simulate clutter 
%            
%   inputs:
%             N_PRI:        Sample Number in one PRI Interval
%             N_pulses:     Transmitted Pulse Number
%             clutter_amp:  constant amplification coefficient depending on
%                           noise_amp
%             PRF:          Pulse Repetition Frequency
%             lambda:       Wavelength(m)
%             c:            Speed of Light (3e8 m/s)
%             fs:           Sampling Frequency (1e6 Hz)
%                           
%    output: 
%             rx:       Received Signal        

        % gerçekçi clutter: menzile göre sönümlenen, hafif doppler
        %                   yayılımlı

        N_Pulse = length(t_pulse);
        clutter = zeros(N_pri,N_pulses);

        range_m = (0:N_pri-1)' * c/(2*fs);
        range_m(1) = range_m(2);

        %Clutter Profile Comparing to Range
        profil = 1./(range_m).^0.5;
        profil = profil / max(profil);
        

        for d = 1 : N_pri - N_Pulse
            %Clutter appearing at each range
            amp = clutter_amp * profil(d)*(randn + 1j*randn);

            %Clutter of very low-speed moving objects like wind
            V_clutter = 0.5 * randn;

            % Calculating Doppler Frequency to consider the doppler effect
            fd = 2*V_clutter/lambda;


           
            idx = d + (1:N_Pulse);

            for p = 1:N_pulses
                clutter(idx,p) = clutter(idx,p) + t_pulse(:)*amp * exp(1j*2*pi*fd*(p-1)/PRF);
            end
        end
end


      

