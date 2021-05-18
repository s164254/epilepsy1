% Matlab script that combines patient ECG sample data in TDMS struct files 
% with seizure period information generated by 01.calculate-seizure-periods.py
% into a single .mat file that is a lot easier to deal with
%
% A struct is written to the mat file with the following attributes:
% id: patient id
% samples: all collected samples
% episodes: A matrix with one row for each episode and columns <episode start index (zero-based)>, <episode sample length>
%

% load common parameters, we need sample frequency and path to patient TDMS files
params = load_params();

% get file names of all available TDMS files 
files = dir(params.tdms_file_path);

% loop over each TDMS file
for i = 1:length(files)
    % extract patient id from file name
    splt = split(files(i).name(9:end), '_');
    pid = splt{1};

    % get file name of corresponding CSV file name from 01.calculate-seizure-periods.py
    csv_fname = fullfile(params.patient_info_path, ['patient-ofs-' pid '.csv']);

    % proceed only if there is a corresponding CSV file
    if isfile(csv_fname)
        % use Matlab readtable to load from CSV file
        ofs = readtable(csv_fname);

        % episodes are collected into info matrix
        info = [];

        % load patient TDMS file
        Output = TDMS_getStruct(fullfile(files(i).folder, files(i).name));
        l = length(Output.Untitled.EKG.data(1, :));

        % process each seizure line in the CSV file
        for s = 1:size(ofs, 1)
            seizure_start_idx = ofs(s, 1).start * params.sf;
            seizure_samples = ofs(s, 2).length * params.sf;

            % append seizure information to info
            info(end + 1, :) = [seizure_start_idx seizure_samples];
        end

        % mat file is generated only if there are episodes in the CSV file
        if length(info) > 0
            patient.id = pid;
            patient.episodes = info;
            patient.samples = Output.Untitled.EKG.data(1, :);
            fname = fullfile('mat', ['patient-all-' pid]);
            save(fname, 'patient')
        end

    end

end
