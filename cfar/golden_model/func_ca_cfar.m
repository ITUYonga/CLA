function ca_threshold_map = func_ca_cfar(data,num_ref,num_guard,threshold_factor)
%FUNC_CA_CFAR : Algorithm to map the CA type adaptive Threshold
%Can Ertürk
%
%   Purpose:  This function generates an adaptive ca_threshold_map
%             by using its cell scanning algorithm. (CENTER AVERAGE)   
%   inputs:
%             data:             Windowed_fft_output
%             num_ref:          Number of Reference Cells
%             num_guard:        Number of Guard Cells
%             threshold_factor: The threshold constant that elevates the
%                               threshold
%
%    outputs: 
%             ca_threshold_map:     Resulting Adaptive Center Average Threshold Mechanism

% Determining the system initals
        [N_range, N_vel] = size(data);
        power = abs(data).^2;
        ca_threshold_map = zeros(N_range, N_vel);

% Scanning reference cells all over range and velocity axises
        for i = 1:N_vel
            for j = 1: N_range

                %Array that contains the list reference cell data of the left and right side
                %of the CUT

                left = (j -num_guard/2 - num_ref/2 : (j - num_guard/2 -1));
                right = ((j + num_guard/2 + 1) :(j + num_guard/2 + num_ref/2));
                left = left(left>0);
                right = right(right <=N_range);


                ref_cells = vertcat(power(left,i), power(right,i));

                if isempty(ref_cells)
                    continue
                end

                % The main difference of CA CFAR -- puts the reference in
                % mean
                ca_threshold_map(j,i) = mean(ref_cells) * threshold_factor;
            end
        end
end

