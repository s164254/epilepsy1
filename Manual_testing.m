%Testing the manually annotated RR intervals.

params = load_params();
pid = '16';
patient = load_patient(pid,params);


%% Calculating CSI values on the manually found RR intervals for patient 16.

[Manual_normal_csi, Manual_seizure_csi] = Manualtest(RR_normalpat16,RR_seizure16,params,patient,50);

%% Calculating CSI values on the manually found RR intervals for patient 5.

[Manual_normal_csi, Manual_seizure_csi] = Manualtest(RR_normalpat4,RR_seizurepat4,params,patient,100);

%% Calculating CSI values on the manually found RR intervals for patient 2.

[Manual_normal_csi, Manual_seizure_csi] = Manualtest(RR_normalpat4,RR_seizurepat4,params,patient,100);


%% Calculating CSI values on the manually found RR intervals for patient 4.

[Manual_normal_csi, Manual_seizure_csi] = Manualtest(RR_normalpat4,RR_seizurepat4,params,patient,100);

%% Calculating CSI values on the manually found RR intervals for patient 16 with the new extended seizure period starting 3 minutes before original seizure start, and ending at seizure end.
HRV=diff(RR_seizurepat16ny)/params.sf;
csi = calc_csi(patient,params,HRV,100);
hold on
plot(csi.modCSI);
plot(csi.CSI);
hold off
max_val_modcsi=max(csi.modCSI); %turns out to be 15.2772 (corresponds to 15277.2 in ms).
max_val_csi=max(csi.CSI); %turns out to be 9.2129

%Both are much lower than the threshold values, even with manual detection.
%They are quite close to the ones found in the seizure area in
%patient_plot_full_csi with automatic detection, which increases our
%confidence that the automatic detection is good.

