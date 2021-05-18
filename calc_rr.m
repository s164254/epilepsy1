% This function was not used in obtaining any of the results in the report.
% However, some of the tested (but ultimately not used) QRS detection
% algorithms crashed or returned incorrect results when sample size was
% sufficiently large. This could have possible also been the case for the chosen QRS
% detection algorithm, if it had been used on larger sets og patient data.
% Thus, to generalize the QRS detection to all patients this function was created and it:
% splits ECG samples into equally sized windows, 
% performs a QRS detection on samples in each window,
% calculates RR length from  each QRS detection and
% combines all that into a single resulting RR vector
% Arguments:
%  qrs_func_name: Name of the QRS functions so that we can call it using feval
%  samples: ECG samples array
%  params: common parameters containg sample frequence (among others)
%
% The resulting RR intervals are calculated as follows:
% 1) Calculate RR from QRS detection
% 2) Remove RR intervals outsize RR_MIN:RR_MAX
% 3) Calculate cumsum of resulting RR intervals
% 3) If cumsum<window size - 2 seconds: append further RR intervals of equal length at the start
% The last step of appending RR intervals was performed, as 
% transitioning from one window to the next sometimes results in a loss of
% RR intervals. This distorts the time axis associated with the RR intervals
% when compared to the time axis of the raw ECG data and thus complicates translation
% of seizure onset- and termination from ECG data to RR intervals. 
% The outcome of this is incorrectly positioned seizure periods on both the RR interval signals
% and the CSI- and modified CSI signals.
% This approach of appending extra RR intervals is only useful for visualization- and verification purposes
%(correctly displaying the seizure periods on the CSI- and modified CSI plots) 
% and would never be implemented in real time detection of epileptic seizures using CSI and modified CSI.


function rr = calc_rr(qrs_func_name, samples, params)
    % 15 min. window size
    secs_win_size = 15 * 60; 

    sample_win_size = secs_win_size * params.sf; % converting from seconds to indexes.

    % number of windows that the samples will be divided into
    num_windows = ceil(length(samples) / sample_win_size);
    RR_MIN = 0.25; %Minimum time between two R peaks in seconds. 
    RR_MAX = 3; %Maximum time between two R peaks in seconds. During cardiac
    %arrest this can be exceeded, however the algorithm was not designed to
    %detect cardiac arrest.

    rr = []; %pre-allocating
    num_samples = length(samples);

    for w = 1:num_windows
        start_idx = sample_win_size * (w - 1); %Making sure that each index starts at the beginning of the next window.
        end_idx = start_idx + sample_win_size; %The final index for a specific window ends at the start of the next window.

        if end_idx > num_samples
            end_idx = num_samples; %This if sentence ensures that we do not go past the length of the data.
            secs_win_size = (end_idx - start_idx) / params.sf;
        end

        rr_indices = feval(qrs_func_name, samples(start_idx + 1:end_idx), params); %Evaluating the given qrs function
        %in order to obtain the rr intervals in each window. Params indicate the sampling frequency.

        % calculate HRV
        temp = diff([rr_indices]) / params.sf;

        % remove RR values below RR_MIN and larger than RR_MAX
        temp = temp((temp >= RR_MIN) & (temp <= RR_MAX));

        % append artificial RR values so accumulated time is sufficiently
        % close to be sample_win_size secs
        acc_time = sum(temp);

        if acc_time < secs_win_size - 2
            % calculate extra RR elements needed
            fact = 0.8;

            if length(rr) > 0
                fact = rr(end);
            end

            rr_extra = round((secs_win_size - acc_time) / fact);
            temp = [ones(1, rr_extra) * fact temp];
        end

        % acc_time check
        acc_time = sum(temp);
        rr = [rr temp];
    end

end
