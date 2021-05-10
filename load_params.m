function params = load_params()
    

    
    % Add TDMS scripts to MATLAB path
    addpath( genpath('v2p6') );

    
    
    params.sf = 512;
    params.patient_info_path='patient_info';

    params.mat_file_path='mat';
    if ~isdir(params.mat_file_path)
        params.mat_file_path='~/sync/philip-public/dtu/ecg_epilepsy/mat';
    end
    params.mat_filename_start='patient-all-';
    params.tdms_file_path = '**/*.tdms';
end
