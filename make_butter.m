function f = make_butter(order,cutoff_frac)
    [B_high,A_high] = butter(order,cutoff_frac,'bandpass');
    
    function filtered = filter_func(samples)
        filtered = filtfilt(B_high,A_high,samples)';
    end
    f = @filter_func;
end