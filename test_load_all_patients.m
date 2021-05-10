params=load_params();
pids=get_all_patient_ids();
for p=1:length(pids)
    patient = load_patient(pids(p),params);
end
