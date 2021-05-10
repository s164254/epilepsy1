function qrs_detect_plot(samples,episode_start_secs,r_info,plot_title)
    qrs=zeros(1,length(samples));
    for i=1:length(qrs_indices)
        qrs(qrs_indices(i))=1;
    end
    t=1:length(samples);
    plot(t,samples,t,qrs*max(samples),t,qrs*min(samples))
    title(plot_title)
end
