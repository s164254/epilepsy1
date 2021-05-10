function r_info = s_detect_qrs_(samples,params)
    qrs = s_detect_qrs(samples,params.b_low,params.b_high,params.b_avg,params.delay);
    r_info.rr=get_HRV(qrs, params.sf);
    r_info.indices = qrs;
end