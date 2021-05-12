% common parameters used by most the scripts
function params = load_params()
    % Add TDMS scripts to MATLAB path
    addpath(genpath('v2p6'));

    % sample frequency
    params.sf = 512;

    params.patient_info_path = 'patient_info';

    % patient mat file path
    params.mat_file_path = 'mat';

    % fallback patient mat file path
    if ~isdir(params.mat_file_path)
        params.mat_file_path = '~/sync/philip-public/dtu/ecg_epilepsy/mat';
    end

    % used by load_patient
    params.mat_filename_start = 'patient-all-';
    
    params.tdms_file_path = '**/*.tdms';
end
