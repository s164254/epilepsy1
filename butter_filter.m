function filtered = butter_filter(ecg, fs)
    order = 1;
    cutoff_frac = 0.6; % from zero to 1
    [B_high,A_high] = butter(order,cutoff_frac,'high');
    filtered = filtfilt(B_high,A_high,ecg)';
end