params = load_params();

pid = '16';
patient = load_patient(pid, params);

ls = length(patient.samples);
start_idx = 7.335 * 10^7;
win_size = 7.4 * 10^7 - start_idx;

samples = patient.samples(start_idx:start_idx + win_size - 1);

f1 = make_sombrero(params.sf);
f2 = make_butter(2, [5 / (params.sf / 2) 30 / (params.sf / 2)]); %n (the first input in butter (make_butter in this case)
%represents one-half the filter order for a band-pass butterworth filter.
%Thus, by using order 2, it is actually 4. However, using filtfilt might double the order again,
%so that the true order is 8. Ask if this is the case. The cut-off frequencies
%represent fractions of the Nyquist frequency, which is half the sampling
%frequency. Thus, we are filtering between 5 Hz and 30 Hz.
filters = {f1, f2};
compare_detect(samples, params, filters);
