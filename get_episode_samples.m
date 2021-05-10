function sub_samples = get_episode_samples(patient, sf, episode, secs_before_episode, secs_after_episode)
    seizure_start_idx = patient.episodes(episode,1);
    seizure_length = patient.episodes(episode,2);

    sub_samples = patient.samples(seizure_start_idx-secs_before_episode*sf+1:seizure_start_idx+seizure_length+secs_after_episode*sf);
end
