% qrs_detect3_ performs a QRS detection on ECG signal in samples
% using qrs_detect3 as detection method and a user specified filter function
% if no filter function is specified qrs_detect3_ defaults to the sombrero filter (make_sombrero)
function rr_indices = qrs_detect3_(samples, params, varargin)
    % fallback to sombrero if no filter function is specified
    if nargin < 3
        filter_func = make_sombrero(params.sf);
    end

    % use user specified filter function
    if nargin >= 3
        filter_func = varargin{1};
    end

    % perform the calculation
    [rr_indices, sign, en_thres] = qrs_detect3(samples, 0.25, 0.6, params.sf, filter_func); % refractory period is 0.25 seconds.
end
