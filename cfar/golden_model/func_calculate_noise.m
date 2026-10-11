function noise_amp = func_calculate_noise(mode, varargin)
%CALCULATE_NOISE : Noise Calculation by Different Methods
%   Can Ertürk
%
%   Purpose: Calculating the noise amplification coefficient by using two
%   modes(physical variables from the article or desired snr value)
%
%   inputs:
%       mode: 
%       two modes are supported: 'snr_db' to calculate noise amp from
%                                desired snr value other varargin inputs are Pr(Received Power) and
%                                snr_db to determine and test the snr inputs
%
%                                'termal' to calculate the noise amp by using physical variables from the article
%                                 other varargin input for this mode is B(boltzman constant)
%
%                                'noisefloor' to calculate noise with the
%                                given noisefloor in the article (-173dBm)
%
%  output: 
%                                noise_amp: The amplification noise constant to simulate the physical received signal


    if strcmp(mode,'termal')
        B = varargin{1};
        Pn = 1.38e-23 * 290 * B;
        noise_amp = sqrt(Pn);

    elseif strcmp(mode,'snr')
        Pr = varargin{1};
        snr_db = varargin{2};
        Pn = Pr / (10^(snr_db / 10));
        noise_amp = Pn;
        

    elseif strcmp(mode, 'noisefloor')
        NF_dBm = varargin{1};
        Pn_W = 10^((NF_dBm-30)/10);
        noise_amp = sqrt(Pn_W);
    end
    
 
end