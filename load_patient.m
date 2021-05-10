function patient = load_patient(patient_id,params)
    load( fullfile(params.mat_file_path, [params.mat_filename_start patient_id]));
    
    % remove the first and last 30 minutes of the signal
    skip_samples = 30*60*params.sf;
    patient.samples=patient.samples(skip_samples+1:length(patient.samples)-skip_samples);
    

    % embed some useful episode variables in the patient stuct
    patient.num_episodes = size(patient.episodes,1);
    patient.num_samples = length(patient.samples);
    episodes=[];
    
    % a seizure episode is set to start 3 minutes before the actual
    % observation start time
    episode_start_offset = 3*60*params.sf;
    for e=1:patient.num_episodes
        episode = patient.episodes(e,:);

        % subtract 30 minutes diue to removal of 30 minutes from the start
        % and the additional seizure start offset
        episode(1) = episode(1) - skip_samples - episode_start_offset;
        episode(2) = episode(2) + episode_start_offset;
        if episode(1)>=0
            if episode(1)+episode(2)>patient.num_samples
                % discard episode if episode end is after signal stop
                break
            end
            episodes(end+1,:)=episode;
        end
    end
    patient.episodes = episodes;
    patient.num_episodes = size(patient.episodes,1);
end    
