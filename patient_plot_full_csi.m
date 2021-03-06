%This script plots the CSI- and modCSI signals for a specified patient.

params = load_params(); %Loading parameters

pid = '16'; %Patient id 
patient = load_patient(pid, params); %Loading patient data
samples = patient.samples; %Extracting samples

temp = qrs_detect3_(samples, params, make_butter(2, [5 / (params.sf / 2) 30 / (params.sf / 2)])); %Performing
%QRS detection, and specifying the use of a bandpass butterworth filter. %the first input in make_butter
%represents one-half the filter order for a band-pass butterworth filter.
%Thus, by using order 2, it is actually 4. The cut-off frequencies
%represent fractions of the Nyquist frequency, which is half the sampling
%frequency. Thus, filtering is done between 5 Hz and 30 Hz.

rr = calc_HRV(temp, params); %rr intervals in s.

rr_time_axis = linspace(0, time(end), length(rr)); %Creating a time axis for
%the rr intervals.

%Visualizing the tachogram (RR intervals) in a seizure area vs. a
%non-seizure area by creating vertical bars around the seizure area.

hold on
plot(rr_time_axis, rr);
xline(patient.episodes(1, 1) / params.sf, 'r')
xline((patient.episodes(1, 1) + patient.episodes(1, 2)) / params.sf, 'r')
hold off

csi = calc_csi_send(patient, params, rr, 100); %Calculating CSI- and modCSI.

%Maximal values baseline values found either in the first half of the data, or the first 24 hours
%of data depending on if the signal is longer than 48 hours or not.

if (length(samples) + 60 * 60 * 512) / 512/60/60 < 48
    mxm = max(csi.modCSI(1:length(csi.modCSI) / 2));
    mx = max(csi.CSI(1:length(csi.CSI) / 2));
else
    mxm = max(csi.modCSI(1:length(find(csi.t < 24 * 60 * 60 - 30 * 60))));
    mx = max(csi.CSI(1:length(find(csi.t < 24 * 60 * 60 - 30 * 60))));
end

%Plotting CSI- and modCSI as a function of time.
hold on
subplot(2, 1, 1);
plot(csi.t, csi.CSI, csi.t, csi.episodes);
title('CSI100*slope for patient 16')
xlabel('Time [s]')
ylabel('CSI100*slope')
subplot(2, 1, 2);
plot(csi.t, csi.modCSI, csi.t, csi.episodes);
title('modCSI100filtered*slope for patient 16')
xlabel('Time [s]')
ylabel('modCSI100filtered*slope')
hold off

%Saving rr data for patient 16, to be used in JAVA.

save('RRdata_pat16.mat', 'temp', 'rr', 'rr_time_axis');
