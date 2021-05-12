% make_sombrero creates a bandpass filter function
% that performs a bandpass filterering on samples
%
% Arguments:
% fs: sample frequence

function f = make_sombrero(fs)
    % == Bandpass filtering for ECG signal designed for a 250 hz signal
    % Comment from original script
    % "this sombrero hat has shown to give slightly better results than a
    % standard band-pass filter. Plot the frequency response to convince
    % yourself of what it does"
    b1 = [-7.757327341237223e-05 -2.357742589814283e-04 -6.689305101192819e-04 -0.001770119249103 ...
            -0.004364327211358 -0.010013251577232 -0.021344241245400 -0.042182820580118 -0.077080889653194 ...
            -0.129740392318591 -0.200064921294891 -0.280328573340852 -0.352139052257134 -0.386867664739069 ...
            -0.351974030208595 -0.223363323458050 0 0.286427448595213 0.574058766243311 ...
            0.788100265785590 0.867325070584078 0.788100265785590 0.574058766243311 0.286427448595213 0 ...
            -0.223363323458050 -0.351974030208595 -0.386867664739069 -0.352139052257134 ...
            -0.280328573340852 -0.200064921294891 -0.129740392318591 -0.077080889653194 -0.042182820580118 ...
            -0.021344241245400 -0.010013251577232 -0.004364327211358 -0.001770119249103 -6.689305101192819e-04 ...
            -2.357742589814283e-04 -7.757327341237223e-05];

    % resample b1 to desired sample frequency
    b1 = resample(b1, fs, 250);

    % b1 is now captured in the closure
    function filtered = filter_func(samples)
        filtered = filtfilt(b1, 1, samples)';
    end

    % return the sombrero filtering function
    f = @filter_func;
end
