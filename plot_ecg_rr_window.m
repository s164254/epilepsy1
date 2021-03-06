% plot_ecg_rr_window performs a QRS detection using function specified in qrs_func_name,
% calculates RR intervals from QRS detected indices
% and plots the ECG signal with QRS detections. In addition, RR intervals
% and CSI are calculated in the specified area. This script was used in
% accessing the accuracy of the qrs detection algorithm.
%
params = load_params();
qrs_func_name = 'qrs_detect3_';
pid = '16';
patient = load_patient(pid, params);
start_idx =patient.episodes(1, 1);
win_size = patient.episodes(1, 2);

samples = patient.samples(start_idx:start_idx + win_size - 1);
ex = feval(qrs_func_name, samples, params, make_butter(2, [5 / (params.sf / 2) 30 / (params.sf / 2)]));

eb_height = 0.1 * (max(samples(1:1000)) - min(samples(1:1000)));
ey = arrayfun(@(x) samples(x), ex);
err = eb_height * ones(length(ex), 1);

%Plotting raw ECG data along detected R peaks that are marked.
hold on
plot(samples)
errorbar(ex, ey, err, 'LineStyle', 'none');
title('QRS detection in ECG area resulting in largest modCSI value for patient 16')
xlabel(['Indices'])
ylabel(['Amplitude'])
hold off

% Plotting RR intervals in the area.
rr = calc_HRV(ex, params);
plot(rr)
title('RR intervals in baseline area with largest modCSI value for patient 16')
xlabel(['Indices'])
ylabel(['RR intervals [s]'])

%Filling in missing RR intervals manually.

rr_filled=calc_HRV(exfilled, params);
plot(rr_filled)
title('RR intervals in area with largest modCSI value for patient 16')
xlabel(['Indices'])
ylabel(['RR intervals [s]'])

%Lorenz plot of RR intervals where the increase in HR occurs. We need to
%pick 100 RR intervals, for us to accurately compare these results with
%those obtained for our algorithm. For the area with largest modCSI value,
%index 125 to 225
%seems fitting. Max value of modCSI is at index 108. index 1 corresponds to
%RR intervals from 1:100, so 108 must correspond to index 108:207.

hold on
rr_vec=rr_filled(108:207);
rr_vec_plus_1=rr_filled(109:208);
plot(rr_vec,rr_vec_plus_1,'.');
title('Lorenz plot in area with largest modCSI for patient 16')
xlabel(['RRn [s]'])
ylabel(['RRn+1 [s]'])
hold off


%Lorenz plot of RR intervals where the increase in HR occurs. We need to
%pick 100 RR intervals, for us to accurately compare these results with
%those obtained for our algorithm. For the seizure area, index 100 to 200
%seems fitting. Largest modCSI values occurs at index 97. So we use 97:196
hold on
rr_vec=rr(97:196);
rr_vec_plus_1=rr(98:197);
plot(rr_vec,rr_vec_plus_1,'.');
title('Lorenz plot in seizure area for patient 16')
xlabel(['RRn [s]'])
ylabel(['RRn+1 [s]'])
hold off

%The following Lorenz plot is for the baseline area with largest modCSI
%values. Here 150 to 250 seems fitting. 153:252 is correct.
hold on
rr_vec=rr(153:252);
rr_vec_plus_1=rr(154:253);
plot(rr_vec,rr_vec_plus_1,'.');
title('Lorenz plot in baseline area with largest modCSI value for patient 16')
xlabel(['RRn [s]'])
ylabel(['RRn+1 [s]'])
hold off

%Now let us investigate the Lorenz plot in the area with largest CSI- and
%modCSI values.

%plotting CSI parameters in the area.
csitest = calc_csi_send(patient, params, rr, 100);
plot(csitest.modCSI);
title('modCSI in baseline area with maximal value for patient 16')
xlabel(['Indices'])
ylabel(['modCSI100filtered*slope'])



