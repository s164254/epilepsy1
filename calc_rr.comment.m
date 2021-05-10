function rr = calc_rr(qrs_func_name,samples, params)
    secs_win_size =  5 * 60; % 5 min. window size
    sample_win_size = secs_win_size * params.sf; % converting from seconds to indexes.
    num_windows = ceil(length(samples) / sample_win_size); %Finding the number of windows. Notice that the windows do not overlap.
    RR_MIN = 0.25; %lowest possible RR interval value.
    RR_MAX = 3; %Highest allowable RR interval value. This one is somewhat debateable, what if the person has a heart attack for instance?

    rr = []; %pre-allocating
    num_samples = length(samples);
    for w=1:num_windows
        start_idx = sample_win_size*(w-1); %Making sure that each index starts at the beginning of the next window.
        end_idx=start_idx+sample_win_size; %The final index for a specific window ends at the start of the next window.
        if end_idx>num_samples
            end_idx=num_samples; %This if sentence ensures that we do not go past the length of the data, similarly to a break statement.
        end
        rr_indices = feval( qrs_func_name, samples(start_idx+1:end_idx), params); %Evaluating the given qrs function in order to obtain the rr intervals in each window. Params indicate the sampling frequency.
        
        % calculate RR
        temp = diff([1 rr_indices]) / params.sf; %The 1 that is used in diff just ensures that the very first rr interval is also included.
        
        % remove RR values below RR_MIN and larger than RR_MAX
        temp = temp((temp>=RR_MIN) & (temp<=RR_MAX));
        
        % append artificial RR values so accumulated time is sufficiently
        % close to be sample_win_size secs. This only seems to be
        % neccessary in the beginning of the dataset. It is done in order
        % to create the time axis for CSI in calc_csi.
        acc_time = sum(temp);
        
        %The following constant displays the maximal allowable difference
        %between the accumulated time of RR intervals in seconds in a
        %window, and the total amount of seconds in that same window. The
        %constant is arbitrarily chosen, but should be quite low,
        %especially if the window size is small.
        
        constant=2;
        
        if acc_time<secs_win_size-constant
            % calculate extra RR elements needed
            rr_extra = round((secs_win_size-acc_time)/constant);
            temp = [ones(1,rr_extra)*temp(1) temp]; %Creating copies of the first value of the RR intervals.
        end
        
        % acc_time check 
        acc_time = sum(temp); %just checking if the accumulated time of RR intervals seems reasonable.
        rr = [rr temp];
    end
end