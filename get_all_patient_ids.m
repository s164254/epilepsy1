function patient_ids = get_all_patient_ids()
    files = dir('mat/*-all-*mat');
    patient_ids = ["a"]; % matlab hack
    for f=1:length(files)
        splt = split(files(f).name(1:end), '-');
        splt = split(splt{3},'.');
        pid = str2double(splt{1});
        patient_ids(end+1) = int2str(pid);
    end
    patient_ids=patient_ids(2:end);
end    
