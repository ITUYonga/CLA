function windowed_output = func_window_processing(signal)
%FUNC_WINDOW_PROCESSING : DOLPH-CHEBYSHEV WINDOWING IMPLEMENTATION
%Can Ertürk
%
%   Purpose: Applying the dolph-chebyshev windowing operation in order to
%            eliminate the side lobes around the targets.
%     
%   input:
%            signal:    The signal that the windowing will be applied
%                     
%    output: 
%            windowed_output: Final result of windowing operation
%                                

    N = size(signal,2);
    window = chebwin(N,80);
    windowed_output = signal .* window.';

end
