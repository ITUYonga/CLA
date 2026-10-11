function fft_output = func_fft_processing(signal,NFFT)
%FUNC_FFT_PROCESSING : Calculates Fast Fourier Transform(FFT)
%Can Ertürk
%
%   Purpose:  Transform the time domain signal into frequency domain with
%             generalized 'fft' function and 'fftshift' to shift the
%             function to the origin
%            
%   inputs:
%             signal:   any time domain signal 
%             NFFT:     number of ffts in order to enchance the scaling
%                       operation
%    output: 
%             fft_output: transformed frequency domain signal


    fft_output = fftshift(fft(signal,NFFT,2),2);



end