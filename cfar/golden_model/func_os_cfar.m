function [cfar_output,threshold_map] = func_os_cfar(data,num_ref,num_guard,k,threshold_factor)
%FUNC_OS_CFAR : Algorithm to distinguish targets from clutter
%Can Ertürk
%
%   Purpose:  This function generates os_cfar_output and its adaptive threshold
%             by using its cell scanning algorithm.    
%   inputs:
%             data:             Windowed_fft_output
%             num_ref:          Number of Reference Cells
%             num_guard:        Number of Guard Cells
%             k:                The reference threshold constant
%             threshold_factor: The threshold constant that elevates the
%                               threshold
%
%    outputs: 
%             cfar_output:       Resulting OS-CFAR Output
%             threshold_map:     Resulting Adaptive Threshold Mechanism


% Generating Empty Function Arrays for handling the dimensions easily
[N_range, N_vel] = size(data);
power = abs(data).^2;
cfar_output = zeros(N_range, N_vel);
threshold_map = zeros(N_range, N_vel);

% SCANNING MODULE
% Each range cell is scanned once and all of the velocity columns are
% processed together (the reference cells are the same for every column).

for j = 1:N_range

    %Array that contains the list reference cell data of the left and right side
    %of the CUT
    left = (j - num_guard/2 - num_ref / 2) : (j - num_guard/2 - 1);
    right = (j + num_guard/2 + 1) : (j + num_guard/2 + num_ref/2);

    left = left(left > 0);
    right = right(right <= N_range);

    % reference cell array is now containing power values (one column for each velocity cell)
    ref_cells = power([left right],:);

    %Checking reference cell whether the overall array is empty or not
    % if empty -- return, no errors
    if isempty(ref_cells)
        continue
    end

    % Sorting each reference cells (column by column)
    sorted = sort(ref_cells,1);

    %The main difference of the OS_CFAR -- The style that used while
    %determining the adaptive threshold -- where do we put the reference

    threshold = sorted(min(k, size(sorted,1)),:) * threshold_factor;
    threshold_map(j,:) = threshold;

    % general cfar output -- if the data is above the threshold then HIGH
    high = power(j,:) > threshold;
    cfar_output(j,high) = power(j,high);
end


end
