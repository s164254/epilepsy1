function r_info = qrs_detect(samples,sf,median_left_right)
    [r_indices,sign,en_thres] = qrs_detect3(samples,0.1,0.6,sf); % refractory period changed from 0.25 -> 0.1 ms
    r_info.indices = r_indices;
    rr = diff(r_indices)/sf;
    if median_left_right>0
        rr = movmedian(rr,median_left_right,median_left_right);
    end
    r_info.rr = rr;
end