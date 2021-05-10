function f = make_qrs_detect3( filter_func, params)
    params_ = params;
    filter_func_ = filter_func;
    
    function rr = detect_func(samples)
        rr = qrs_detect3_(samples,params_,filter_func_);
    end
    f = @detect_func;
end