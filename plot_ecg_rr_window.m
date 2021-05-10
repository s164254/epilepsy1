params = load_params();
qrs_func_name = 'qrs_detect3_';
%qrs_func_name = 'pan_tompkin_';
pid = '16';
patient = load_patient(pid, params);
start_idx=patient.episodes(1,1);
win_size = patient.episodes(1,2);


samples = patient.samples(start_idx:start_idx+win_size-1);
ex = feval(qrs_func_name, samples, params,make_butter(2,[5/(params.sf/2) 30/(params.sf/2)]));
%ex = feval(qrs_func_name,samples,params);
%ex = feval(qrs_func_name, samples, params);

%sl = length(samples);
%x = 1:sl;
eb_height=0.1*(max(samples(1:1000))-min(samples(1:1000)));
ey=arrayfun(@(x) samples(x),ex);
err=eb_height*ones(length(ex),1);

hold on
plot(samples)
errorbar(ex,ey,err,'LineStyle','none');
xlabel(['Indices'])
ylabel(['Amplitude'])
hold off


% Plotting RR intervals in the area.
rr=calc_HRV(ex,params);
plot(rr)
xlabel(['Indices'])
ylabel(['RR intervals [s]'])

%plotting CSI parameters in the area.
csitest = calc_csi_for_sending(patient,params,rr,100);
plot(csitest.CSI);
xlabel(['Indices'])
ylabel(['CSI100*slope'])



