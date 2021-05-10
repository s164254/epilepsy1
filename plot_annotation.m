params = load_params();

pid = '16';
patient = load_patient(pid,params);
episode = patient.episodes(1,:);

seizure_samples = patient.samples(episode(1,1)+1:episode(1,1)+episode(1,2));
x=1:length(seizure_samples);
annotations=400:400:20005;
ex=annotations;
ey=arrayfun(@(x) seizure_samples(x),ex);

eb_height=0.1*(max(seizure_samples(1:1000))-min(seizure_samples(1:1000)));
err=eb_height*ones(length(ex),1);
hold on
plot(x,seizure_samples);
errorbar(ex,ey,err);
hold off
