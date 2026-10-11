function rx = func_get_received_signal(pulse,N_pri,pulse_number,R_tgt,V_tgt,rcs_tgt,Pt,Gt,noise_amp)
%FUNC_GET_RECEIVED_SIGNAL : Calculates and simulates the estimate received signal
%Can Ertürk
%
%   Purpose:  Calculating the estimate received signal via the Radar
%             Equation uses the parameters; Pt, Gt, R_tgt, V_tgt...
%             Finally  all the effects will be multiplied with the
%             transmitted signal (doppler shift is included)
%            
%   inputs:
%             pulse:        transmitted signal
%             N_PRI:        Pulse Repetition Interval (Samples)
%             pulse_number: Transmitted Pulse Number
%             R_tgt:        Range array of the targets (m)
%             V_tgt:        Velocity array of the targets (m/s)
%             rcs_tgt:      Radar Cross Section of the targets (m^2)
%             Pt:           Transmitted Power (W)
%             Gt:           Antenna Gain (W)
%             noise_amp:    Applied noise constant to make more realistic both phase and real
%                           part of the signal.
%    output: 
%             rx:       Received Signal


% Adjusting the physical constants
        c = 3e8;
        fc = 3e9;
        fs = 1e6;
        PRF = 1e3;
        lambda = c / fc;
        N_pulse = length(pulse);
        rx = zeros(N_pri ,pulse_number);  
                                               

        for i = 1:pulse_number
           for t = 1:length(R_tgt)
               d = round(2*R_tgt(t)/c*fs);
               fd = 2*V_tgt(t)*fc/c;
               Pr = (Pt* Gt(t)^2 *lambda^2 *rcs_tgt(t))/((4*pi)^3*R_tgt(t)^4);
               attenuation = sqrt(Pr);
               idx = d + ((-N_pulse/2+2):(N_pulse/2+1));
               idx = floor(idx);
               
                 if max(idx) <=N_pri
                   rx(idx,i) = rx(idx,i) + pulse(:) * attenuation * exp(1j * 2 * pi * fd * (i-1) /PRF);
                 end
           end
        end

       
        rx = rx + noise_amp .* (rand(N_pri, pulse_number) .* exp(1j*2*pi.*rand(N_pri,pulse_number)) );
        
      

end