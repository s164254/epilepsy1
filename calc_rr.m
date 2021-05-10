function rr = calc_rr(qrs_func_name,samples, params)
    secs_win_size =  15 * 60; % 15 min. window size5
    sample_win_size = secs_win_size * params.sf; % 30 min. window size5
    num_windows = ceil(length(samples) / sample_win_size);
    RR_MIN = 0.25;
    RR_MAX = 3; %Consider removing RR_max for the final report.

    rr = [];
    num_samples = length(samples);
    for w=1:num_windows
        start_idx = sample_win_size*(w-1);
        end_idx=start_idx+sample_win_size;
        if end_idx>num_samples
            end_idx=num_samples;
            secs_win_size = (end_idx-start_idx) / params.sf;
        end
        rr_indices = feval( qrs_func_name, samples(start_idx+1:end_idx), params);
        
        % calculate RR
        temp = diff([rr_indices]) / params.sf;
        
        % remove RR values below RR_MIN and larger than RR_MAX
        temp = temp((temp>=RR_MIN) & (temp<=RR_MAX));
        
        % append artificial RR values so accumulated time is sufficiently
        % close to be sample_win_size secs
        acc_time = sum(temp);
        
        if acc_time<secs_win_size-2
            % calculate extra RR elements needed
            fact=0.8;
            if length(rr)>0
                fact=rr(end);
            end
            rr_extra = round((secs_win_size-acc_time)/fact);
            temp = [ones(1,rr_extra)*fact temp];
        end
        
        % acc_time check 
        acc_time = sum(temp);
        rr = [rr temp];
    end
end