function params = load_params()
    
% parameters below are no longer used due to use of new QRS detection
    % algorithm
    load s_b_coeff.mat;
    
    % Add TDMS scripts to MATLAB path
    addpath( genpath('v2p6') );

    params.b_avg = b_avg;
    params.b_high = b_high;
    params.b_low = b_low;
    params.delay = delay;
    %params.desc_filt = desc_filt;
    
    params.sf = 512;
    params.patient_info_path='patient_info';

    params.mat_file_path='mat';
    if ~isdir(params.mat_file_path)
        params.mat_file_path='~/sync/philip-public/dtu/ecg_epilepsy/mat';
    end
    params.mat_filename_start='patient-all-';
    params.tdms_file_path = '**/*.tdms';
end
