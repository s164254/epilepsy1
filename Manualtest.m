function [Manual_normal_csi, Manual_seizure_csi] = Manualtest(RR_normal,RR_seizure,params,patient,N)

%Function that calculates CSI on data with manually annotated RR intervals.
%Calculating RR intervals in s.
Manual_normal_HRV=(diff(RR_normal)./params.sf);

Manual_seizure_HRV=(diff(RR_seizure)./params.sf);

%Notice that we do not include the very first difference between index 0
%and the first RR interval. This is omitted because it is sometimes very
%short and inaccurate when just jumping into the middle of a signal (like is done with manual annotations).

Manual_normal_csi=calc_csi(patient,params,Manual_normal_HRV, N);

Manual_seizure_csi=calc_csi(patient, params, Manual_seizure_HRV, N);



hold on
plot(Manual_seizure_csi.modCSI,'DisplayName','seizuremodCSI')
plot(Manual_normal_csi.modCSI,'DisplayName','normalmodCSI')
plot(Manual_seizure_csi.CSI,'DisplayName','seizureCSI')
plot(Manual_normal_csi.CSI,'DisplayName','normalCSI')
hold off
legend

end

