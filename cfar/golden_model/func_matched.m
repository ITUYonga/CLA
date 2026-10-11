function matched_output = func_matched(transmitted_signal,received_signal)
%FUNC_MATCHED : Match Filter Implementation
%Can Ertürk
%
%   Purpose: To apply "shift and scale" concept of convolution operation
%            between received and transmitted signals
%     
%   inputs:
%             transmitted_signal:    The pulse that is selected to transmit
%             received_signal:       The pulse that the antenna received
%                     
%    output: 
%             matched_output:        Final result of convolution of the
%                                    signals

    matched_filter = conj(fliplr(transmitted_signal));
    N = length(transmitted_signal);
    matched_output = zeros(size(received_signal));

    for idx = 1:size(received_signal,2)
        matched_output(:,idx) = conv(received_signal(:,idx),matched_filter(:), 'same');

    end


end