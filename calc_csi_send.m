function csi = calc_csi(patient, params, rr, N)
    % Using the HRV (medRR) as input calculate CSI and modified CSI slope
    % Calculating ModCSI100filtered*slope and CSI100*slope:
    fact = 1 / sqrt(2); %Constant that is part of the CSI formulas

    CSI = [];
    modCSI = [];

    % Median filter, using the median of the previous 7 rr intervals as
    % described in the article under section 2.6.
    medRR = movmedian(rr, [7 0]);

    % time-axis for moving slope calculation for modCSI and CSI.
    tm = cumsum(medRR);

    a = [];
    % calculate slope and modified csi for each medRR window
    lrr = length(rr);
    end_idx = lrr - N;
    modCSI = ones(1, end_idx);

    % Vectors used in the modCSI calculation.
    medRRSub = fact * (medRR(1:lrr - 1) - medRR(2:lrr));
    medRRAdd = fact * (medRR(1:lrr - 1) + medRR(2:lrr));

    % Vectors used in the CSI calculation.
    RRSub = fact * (rr(1:lrr - 1) - rr(2:lrr));
    RRAdd = fact * (rr(1:lrr - 1) + rr(2:lrr));

    i1 = N; % window size, 100 should be optimal according the the articles.

    for i = 1:end_idx
        sd1mod = std(medRRSub(i:i1));
        sd2mod = std(medRRAdd(i:i1));
        slope = abs(polyfit(tm(i:i1 + 1), medRR(i:i1 + 1), 1)); % calculation of slope using the least-squares method as
        % described in section 2.6.
        a(end + 1) = slope(1); % slope is always calculated using median filtered rr data
        % but CSI is calculated without median filtered RR data. This vector is created as the
        % slope is used in the CSI calculation.
        modCSI(i) = ((4 * sd2mod).^2) / (4 * sd1mod) * slope(1);
        i1 = i1 + 1;
    end

    % calculation of csi a(i) corresponds to the slope.
    CSI = ones(1, end_idx);
    i1 = N;

    for i = 1:end_idx
        sd1 = std(RRSub(i:i1));
        sd2 = std(RRAdd(i:i1));
        CSI(i) = (4 * sd2) / (4 * sd1) * a(i);
        i1 = i1 + 1;
    end

    % Making a struct out of the CSI parameters.
    csi.CSI = CSI;
    csi.modCSI = modCSI;

    % estimated time axis
    time_start_idx = N; %Picking the initial index of the time axis as the index the first index after one CSI window computation.
    t = cumsum(rr);
    csi.t = t(time_start_idx + 1:time_start_idx + length(CSI)); %CSI is about 100 values shorter than rr hence this works.

    % series for visualizing seizure start and end
    episode_times = [];

    for e = 1:patient.num_episodes %valid means that those episodes for patient 2 that exceed time axis are not included.
        episode_times = [episode_times patient.episodes(e, 1) (patient.episodes(e, 1) + patient.episodes(e, 2))]; %(e,1) denotes the index of an episode, (e,2) denotes the number of samples (length) of an episode.
    end

    % This new variable in the CSI struct contains bars corresponding to the max height of the modified CSI signal around the seizures.
    csi.episodes = zeros(1, length(CSI)); 

    % The max height of the modified CSI signal, this is used to ensure that the bars are of proper height to clearly indicate position of seizures.
    mx = max(modCSI); 

    for et = 1:length(episode_times)
        idx = find(csi.t > episode_times(et) / params.sf); % When the time on the CSI axis exceeds the time of an episode, a vertical bar corresponding to the max height of the modified CSI signal is placed immediately following the episode.
        csi.episodes(idx(1)) = mx; % This places the bar (or finds the index where it needs to be placed).
    end
