function rr_indices = pan_tompkin_(samples,params)
    [HRV,qrs_amp_raw,rr_indices,delay] = pan_tompkin(samples,params.sf,0);
end