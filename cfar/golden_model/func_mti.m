function mti_output = func_mti(signal)
%FUNC_MTI : Implementing the "Moving Target Indicator"
%Can Ertürk
%
%   Purpose: To apply 'three pulse canceller' algorithm 
%            (x[p] = x[p] - 2*x[p+1] + x[p+2]) and
%            eliminate the target that has velocity of 0 m/s
%     
%   inputs:
%            signal:    The pulse that is selected to implement the
%                       algorithm, generally the matched_output
%                     
%    output: 
%            mti_output: Final result of three pulse cancelled
%                        signal
%                                

%matched_output : [N_PRI x N_Pulse]

mti_output = zeros(size(signal,1), size(signal,2) - 2);

%mti_output : [N_PRI x N_Pulse -2]
  

for i = 1: size(signal, 1)
        for p = 1:size(signal,2) - 2

            %Three Pulse Canceller
            mti_output(i,p) = signal(i,p) - 2 * signal(i,p+1) + signal(i,p+2);

        end
    end
end