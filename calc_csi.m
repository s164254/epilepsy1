%This function was not used in obtaining the results displayed in the
%project. It is made to be compatible with calc_rr, and thus must be used
%when using calc_rr to calculate HRV. As calc_rr was not used in the
%results obtained in the project, this function was not used either. It is
%still relevant for the reasons given in the calc_rr script.

function csi = calc_csi(patient, params, rr, N)
    %Using the HRV (medRR) as input calculate CSI and modified CSI slope
    %Calculating ModCSI100filtered*slope and CSI100*slope:
    fact = 1 / sqrt(2);

    CSI = [];
    modCSI = [];

    % Median filter, using the median of the previous 7 medRR intervals:
    medRR = movmedian(rr, [7 0]);

    % time-axis for moving slope calculation for modCSI and CSI.
    tm = cumsum(medRR);

    a = [];
    % calculate slope and modified csi for each medRR window
    lrr = length(rr);
    end_idx = lrr - N;
    modCSI = ones(1, end_idx);

    medRRSub = fact * (medRR(1:lrr - 1) - medRR(2:lrr));
    medRRAdd = fact * (medRR(1:lrr - 1) + medRR(2:lrr));
    RRSub = fact * (rr(1:lrr - 1) - rr(2:lrr));
    RRAdd = fact * (rr(1:lrr - 1) + rr(2:lrr));

    i1 = N;

    for i = 1:end_idx
        sd1mod = std(medRRSub(i:i1));
        sd2mod = std(medRRAdd(i:i1));
        slope = abs(polyfit(tm(i:i1 + 1), medRR(i:i1 + 1), 1));
        a(end + 1) = slope(1);

        if sd1mod == 0 % This if sentence is used in case the standard deviation becomes zero
            % as a result of the appended RR intervals from calc_rr.
            modCSI(i) = 0;
        else
            modCSI(i) = 4 * sd2mod * sd2mod / sd1mod * slope(1);
        end

        i1 = i1 + 1;
    end

    % calculation of csi a(i) corresponds tho the slope.
    CSI = ones(1, end_idx);
    i1 = N;

    for i = 1:end_idx
        sd1 = std(RRSub(i:i1));
        sd2 = std(RRAdd(i:i1));
        
        if sd1mod == 0 % This if sentence is used in case the standard deviation becomes zero
            % as a result of the appended RR intervals from calc_rr.
            modCSI(i) = 0;
            CSI(i) = 0;
        else
            CSI(i) = (4 * sd2) / (4 * sd1) * a(i);
        end

        i1 = i1 + 1;
    end

    %Making a struct out of the CSI parameters.
    csi.CSI = CSI;
    csi.modCSI = modCSI;

    % estimated time axis
    time_start_idx = N; %Picking the initial index of the time axis as the index in the middle of the first N values in the first window.
    t = cumsum(rr);
    csi.t = t(time_start_idx + 1:time_start_idx + length(CSI)); %CSI is about 100 values shorter than medRR hence this works.

    % series for visualizing seizure start and end
    episode_times = [];

    for e = 1:patient.num_episodes %valid means that those episodes for patient 2 that exceed time axis are not included.
        episode_times = [episode_times patient.episodes(e, 1) (patient.episodes(e, 1) + patient.episodes(e, 2))]; %(e,1) denotes the index of an episode, (e,2( denotes the number of samples (length) of an episode)
    end

    csi.episodes = zeros(1, length(CSI)); %This new variable in the CSI struct contains bars corresponding to the max height of the modified CSI signal around the seizures.
    mx = max(modCSI); %The max height of the modified CSI signal, this is used to ensure that the bars are of proper height to clearly indicate position of seizures.

    for et = 1:length(episode_times)
        idx = find(csi.t > episode_times(et) / params.sf); %When the time on the CSI axis exceeds the time of an episode, a vertical bar corresponding to the max height of the modified CSI signal is placed immediately following the episode.

        if length(idx) > 0 %This if sentence is only used as filling extra medRR intervals into the signal resulted in some infinity value problems.
            csi.episodes(idx(1)) = mx; %This places the bar (or finds the index where it needs to be placed).
        end

    end

end
