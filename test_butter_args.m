params = load_params();

ls=length(samples);
start_idx=ceil(8.2/200*ls);
win_size = ceil(13/200*ls) - start_idx;
pid = '16';
patient = load_patient( pid, params);

samples = patient.samples(start_idx:start_idx+win_size-1);
binranges=[0 0.3:0.1:2];

fracts = 0.25:0.05:0.4;
hist_mat = [];
for f=1:length(fracts)
    filter = make_butter(2,fracts(f));
    %plot(x,samples, x, filter(samples));
    
    rr = calc_rr_no_fill( make_qrs_detect3(filter,params), samples,params );
    plot(rr);
    histo = histc( rr, binranges);
    hist_mat(end+1, :) = histo;
end
rr = calc_rr_no_fill( make_qrs_detect3(make_sombrero(params.sf),params), samples,params );
hist_mat(end+1, :) = histc( rr, binranges);

bar(hist_mat);
