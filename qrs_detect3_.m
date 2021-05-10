function rr_indices = qrs_detect3_(samples,params,varargin)
    if nargin<3
        filter_func = make_sombrero( params.sf);
    end
    if nargin>=3
        filter_func = varargin{1};
    end
    [rr_indices,sign,en_thres] = qrs_detect3(samples,0.25,0.6,params.sf,filter_func); % refractory period changed from 0.25 -> 0.1 ms
end