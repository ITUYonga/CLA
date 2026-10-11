function detected_idx = func_cfar_post_processing(data, threshold_map,peak_ratio, max_gap)
%FUNC_POST_PROCESSING : Post processing function to detect targets accurate
%Can Ertürk
%
%   Purpose: To group detected indexes by looking their heights and distances.
%            if two neighbor detections are close and difference of their
%            heights is small -- there are two separate targets
%            
%            if two neighbor detections are close and difference of their
%            heights is large -- there is a side lobe not a target, take
%            the large one.
%
%            As a result, better Pd and Pfa values are obtained
%               
%   inputs:
%             data:          Windowed_fft_output 
%             threshold_map: Calculated adaptive os_cfar threshold map
%
%             peak_ratio:    the determined tolerance constant to compare two peak
%                            ratio of each two neighbor detections.
%                            
%             max_gap:       the determined tolerance constant to compare two ranges
%                            of each neighbor indexes.
%    output: 
%             detected_idx: An array that contains the final filtered and
%                           accurate detections to inform the pilot.

input_max = max(abs(data).^2,[],2);
threshold_max = max(threshold_map, [],2);

% our base parameter is the values that input data that is higher than
% threshold

crossing = input_max > threshold_max;

% Determining the potential detections

candidates = [];
i = 1;
while i <= length(crossing)
    if crossing(i)
        j = i;
        while j <= length(crossing) && crossing(j), j= j+1; end
        [~,rel] = max(input_max(i : j-1));
        candidates(end+1) = (i+rel-1);
        i = j;
    else
        i = i+1;
    end
end

if isempty(candidates)
    detected_idx = [];
    return
end

% First candidate index is the reference and also the first index of detected_idx. 

detected_idx = candidates(1);

for k = 2:length(candidates)

    %determining two neighbor
    previous = detected_idx(end);
    current = candidates(k);

    % is_close - Calculating two neighbor distances
    is_close = (current -previous) < max_gap;
    ratio = input_max(current) / input_max(previous);
    if is_close && (ratio < peak_ratio || ratio > 1/peak_ratio)

        %Close and very different height lobe, keep the larger
        if input_max(current) > input_max(previous)
            detected_idx(end) = current;
        end

    else

    %Far apart or similar height : seperate target
    detected_idx(end+1) = current;
    end
end
end

 