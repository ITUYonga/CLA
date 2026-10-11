function lfm_pulse = func_lfm_gen(k_lfm,t_p)
%FUNC_LFM_GEN : Generates the lfm type signal
%Can Ertürk
%
%   Purpose: To generate LFM Type Signal
%     
%   inputs:
%             k_lfm:    Band Interval (samples) 
%             t_p:      Period of the desired LFM Signal (samples)
%                     
%    output: 
%             lfm_pulse: Final generated lfm signal

    lfm_pulse = exp(1j*pi*k_lfm*t_p.^2); % complex lfm e^(j0)
end