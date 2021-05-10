params = load_params();
files = dir(params.tdms_file_path);

for i = 1:length(files)
    splt = split(files(i).name(9:end), '_');
    pid = splt{1};
    csv_fname = fullfile(params.patient_info_path, ['patient-ofs-' pid '.csv']);

    if isfile(csv_fname)
        ofs = readtable(csv_fname);

        % first element is number of seizures
        info = [];

        % load patient TDMS file
        Output = TDMS_getStruct(fullfile(files(i).folder, files(i).name));
        csv_fname
        l = length(Output.Untitled.EKG.data(1, :));

        for s = 1:size(ofs, 1)
            seizure_start_idx = ofs(s, 1).start * params.sf;
            seizure_samples = ofs(s, 2).length * params.sf;

            info(end+1,:) = [seizure_start_idx seizure_samples];
        end

        if length(info) > 1
            patient.id = pid;
            patient.episodes = info;
            patient.samples = Output.Untitled.EKG.data(1, :);
            fname = fullfile('mat', ['patient-all-' pid]);
            save(fname, 'patient')
        end
    end

end
