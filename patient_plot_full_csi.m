params = load_params();

pid = '10';
patient = load_patient(pid,params);
samples = patient.samples;


%samples = patient.samples(1:3*15*60*params.sf);
%rr = calc_rr_qrs_detect3(samples,params,"butter_filter");
%qrs_detect_func=make_qrs_detect3(make_butter(4,[5/(params.sf/2) 30/(params.sf/2)]), params);
%rr = calc_rr_no_fill(qrs_detect_func,samples,params);
%rr=calc_rr_pan_tompkin_no_rr_filling(samples,params);

temp=qrs_detect3_(samples,params,make_butter(2,[5/(params.sf/2) 30/(params.sf/2)]));

%temp=pan_tompkin_(samples,params);
rr=calc_HRV(temp,params); %rr intervals in s.

time=cumsum(rr);
timelost=(length(samples)/params.sf)-time(end);

rr_time_axis=linspace(0,time(end),length(rr));

%We visualize the tachogram (RR intervals) in the seizure area vs. a
%non-seizure area by creating vertical bars around the seizure area.

hold on
plot(rr_time_axis,rr);
xline(patient.episodes(1,1)/params.sf,'r')
xline((patient.episodes(1,1)+patient.episodes(1,2))/params.sf,'r')
hold off



%plot(rr_time_axis,rr);


csi = calc_csi_for_sending(patient,params,rr,100);


%Maximal values in either the first half of the data, or the first 24 hours
%of data depending on if the signal is longer than 48 hours or not.

if (length(samples)+60*60*512)/512/60/60<48
mxm = max(csi.modCSI(1:length(csi.modCSI)/2));
mx=max(csi.CSI(1:length(csi.CSI)/2));
else
mxm = max(csi.modCSI(1:length(find(csi.t<24*60*60-30*60))));
mx=max(csi.CSI(1:length(find(csi.t<24*60*60-30*60))));
end


hold on
subplot(2,1,1);
plot(csi.t,csi.CSI,csi.t,csi.episodes);
title('CSI100*slope for patient 10')
xlabel('Time [s]') 
ylabel('CSI100*slope')
subplot(2,1,2);
plot(csi.t,csi.modCSI,csi.t,csi.episodes);
title('modCSI100filtered*slope for patient 10')
xlabel('Time [s]') 
ylabel('modCSI100filtered*slope')
hold off


hold on
subplot(2,1,1);
plot(csi.CSI);
title('CSI100*slope for patient 5')
xlabel('Time [s]') 
ylabel('CSI100*slope')
subplot(2,1,2);
plot(csi.modCSI);
title('modCSI100filtered*slope for patient 5')
xlabel('Time [s]') 
ylabel('modCSI100filtered*slope')
hold off

%Saving rr data for JAVA.

save('RRdata_pat16.mat','temp','rr','rr_time_axis');


% Highest modCSI peak located at between index 75000 and 77000 in the
% signal. This is 75000/202863=36.97% into the signal. We investigate the
% RR interval detection 36.97% into the raw signal.

%csi_snip = calc_csi(patient,params,rr(74000:77000),100);

plot(csi_snip.modCSI)

%rr_snip=calc_rr_qrs_detect3(samples(1000000:1050000),params);

%x-value 32078


%Using the Pan-Tompkin algorithm on the ecg data where manuel annotations
%were made, in order investigate if there is a problem with the algorithm.

i1=patient.episodes(1,1)+1;
i2=patient.episodes(1,1)+patient.episodes(1,2);
rr_seizure_snip=calc_rr_pan_tompkin_no_rr_filling(samples(i1:i2), params);
rr_normal_snip=calc_rr_pan_tompkin_no_rr_filling(samples(1000000:1000000+patient.episodes(1,2)), params);
seizure_CSI_snip=calc_csi(patient,params,rr_seizure_snip, 100);
normal_CSI_snip=calc_csi(patient,params,rr_normal_snip, 100);

hold on
plot(seizure_CSI_snip.modCSI,'DisplayName','seizure')
plot(normal_CSI_snip.modCSI,'DisplayName','normal')
hold off
legend

%Almost identical to the manually obtained results, so it seems that our
%Pan Tompkin algorithm works just fine.
length(samples(i1:i2))


%% Testing the original Pan tompkins algorithm from the first hand in
load s_b_coeff.mat;

RR_new=s_detect_qrs(samples,b_low,b_high,b_avg,delay);

HRV=get_HRV(RR_new,1000,512);

plot(HRV)

%It does not seem to work very well (too many spikes). The one from mathworks seems to be the
%best one.


%Test the ecg_noisecancellation function when you have obtained the p-wave
%function.



