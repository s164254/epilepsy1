function patient_plot_csi(pid, secs_before_episode, secs_after_episode)
    params = load_params();
    patient = load_patient(pid,params);
    for e=1:patient.num_episodes
        sub_samples = get_episode_samples( patient, params.sf, e, secs_before_episode, secs_after_episode);

        r_info = qrs_detect(sub_samples,params.sf,2);

        %qrs_detect_plot(sub_samples, secs_before_episode, r_info,'qrs_detect.m')

        plot_csi(r_info, 100, secs_before_episode);
    end
end
