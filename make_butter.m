% make_butter creates a butterworth filter function
% that performs a butterworth filterering on samples
% with butterwoth filter arguments order and cutoff_frac
function f = make_butter(order, cutoff_frac)
    % create butterworth filtering arguments
    % they are now captured in the closure
    [B_high, A_high] = butter(order, cutoff_frac, 'bandpass');

    function filtered = filter_func(samples)
        filtered = filtfilt(B_high, A_high, samples)';
    end

    % return the butterworth filtering function
    f = @filter_func;
end
