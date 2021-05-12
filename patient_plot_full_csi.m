params = load_params();

pid = '10';
patient = load_patient(pid, params);
samples = patient.samples;

temp = qrs_detect3_(samples, params, make_butter(2, [5 / (params.sf / 2) 30 / (params.sf / 2)]));

rr = calc_HRV(temp, params); %rr intervals in s.

time = cumsum(rr);
timelost = (length(samples) / params.sf) - time(end);

rr_time_axis = linspace(0, time(end), length(rr));

%We visualize the tachogram (RR intervals) in the seizure area vs. a
%non-seizure area by creating vertical bars around the seizure area.

hold on
plot(rr_time_axis, rr);
xline(patient.episodes(1, 1) / params.sf, 'r')
xline((patient.episodes(1, 1) + patient.episodes(1, 2)) / params.sf, 'r')
hold off

csi = calc_csi_send(patient, params, rr, 100);

%Maximal values in either the first half of the data, or the first 24 hours
%of data depending on if the signal is longer than 48 hours or not.

if (length(samples) + 60 * 60 * 512) / 512/60/60 < 48
    mxm = max(csi.modCSI(1:length(csi.modCSI) / 2));
    mx = max(csi.CSI(1:length(csi.CSI) / 2));
else
    mxm = max(csi.modCSI(1:length(find(csi.t < 24 * 60 * 60 - 30 * 60))));
    mx = max(csi.CSI(1:length(find(csi.t < 24 * 60 * 60 - 30 * 60))));
end

hold on
subplot(2, 1, 1);
plot(csi.t, csi.CSI, csi.t, csi.episodes);
title('CSI100*slope for patient 10')
xlabel('Time [s]')
ylabel('CSI100*slope')
subplot(2, 1, 2);
plot(csi.t, csi.modCSI, csi.t, csi.episodes);
title('modCSI100filtered*slope for patient 10')
xlabel('Time [s]')
ylabel('modCSI100filtered*slope')
hold off

%Saving rr data for JAVA.

save('RRdata_pat16.mat', 'temp', 'rr', 'rr_time_axis');
