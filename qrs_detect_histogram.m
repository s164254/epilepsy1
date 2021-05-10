function qrs_detect_histogram(samples,params,qrs_detect_funcs,binranges)
    nff = length(qrs_detect_funcs);
    for i=1:nff
        rr = calc_rr_no_fill(qrs_detect_funcs{i},samples,params);
        %histo = histc( rr, binranges);
        subplot(nff,1,i);
        histogram(rr,binranges);
    end
end
