function plot_csi(r_info, N, secs_before_episode)
    [modCSI,CSI]=calc_csi(r_info.rr,N);
    t=1:length(modCSI);
    
    % find index of the first CSI value that has seizure start in the middle of the CSI calculating window (N rr values)
    % index is an approximate value due to: 
    % 1) rr values are notequally distr. across window
    % 2) if mov. median filter has been applied to rr values
    rr_cumsum = cumsum(r_info.rr);
    episode_start_idx = find(rr_cumsum>secs_before_episode,1) - N/2;
    episode = zeros(1,length(t));
    %episode(episode_start_idx(1))=max(modCSI);
    
    % normalize CSI to same max as modCSI
    fact = max(modCSI)/max(CSI);
    %plot(t,modCSI,t,fact*CSI); %,t,episode);
    plot(t,CSI); %,t,episode);
    title('modCSI, CSI normalized, seizure start');
end
