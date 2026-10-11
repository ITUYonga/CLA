function [hits,n_valid,false_alarms,target_idx,valid,pattern_dB,hit_each] = func_score_detections(detected_idx,R_tgt,V_tgt,Gt_eff,Gt_max)
%FUNC_SCORE_DETECTIONS : Compares the detections with the real targets
%
%   Purpose:  One common rule for func_performance and func_monte_carlo to
%             count the hits and the false alarms of a trial.
%
%             A target is 'valid' (expected to be seen) if it is moving
%             (v ~= 0, because MTI cancels the static ones) and the beam
%             illuminates it (target gain is at most 3 dB lower than the
%             boresight gain).
%             A valid target is hit if a detection is in the tolerance of
%             its range cell. A detection is a false alarm if it is not near
%             to any valid target (a detection near to a target that the
%             beam does not illuminate is clutter).
%
%   inputs:
%             detected_idx:   Range cell indexes of the detections
%             R_tgt, V_tgt:   Target distances (m) and velocities (m/s)
%             Gt_eff:         (optional) Effective gain of each target (linear)
%             Gt_max:         (optional) Gain at the boresight (linear)
%                             if they are not given, all targets are illuminated
%
%    outputs:
%             hits:           Number of the valid targets that are detected
%             n_valid:        Number of the valid targets
%             false_alarms:   Number of the false alarms
%             target_idx:     Range cell of each target after matched filter
%             valid:          Logical array, valid targets
%             pattern_dB:     Antenna pattern of each target (dB)
%             hit_each:       Logical array, valid targets that are detected

        c = 3e8;
        fs = 1e6;
        tol = 5;

        % A target with delay d samples is seen at the cell d+1 after matched filter
        target_idx = round(2*R_tgt/ c * fs) + 1;
        non_static = V_tgt ~= 0;

        if nargin < 5
            in_beam = true(size(R_tgt));
            pattern_dB = zeros(size(R_tgt));
        else
            pattern_dB = 10*log10(Gt_eff / Gt_max);
            in_beam = pattern_dB >= -3;
        end
        valid = non_static & in_beam;
        n_valid = sum(valid);

        hits = 0;
        hit_each = false(size(R_tgt));
        for h = find(valid)
            if any(abs(detected_idx - target_idx(h)) <= tol)
                hits = hits + 1;
                hit_each(h) = true;
            end
        end

        false_alarms = 0;
        for d = 1 : length(detected_idx)
            if ~ any(abs(target_idx(valid) - detected_idx(d)) <= tol)
                false_alarms = false_alarms + 1;
            end
        end

end
