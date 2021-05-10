%used to compare accuracy of butterworth- and Sombrero filters in QRS detection accuracy
function compare_detect(samples,params,filter_funcs)
    err_bar_height=0.1*(max(samples(1:1000))-min(samples(1:1000)));
    
    %ex_all=[];
    %ey_all=[];
    err = [];
    nm = length(filter_funcs);
    for m=1:nm
        ex = qrs_detect3_( samples, params, filter_funcs{m});
        err=err_bar_height*ones(length(ex),1);
        %ex_all(end+1,:) = ex;
        %ey_all(end+1,:)=arrayfun(@(x) samples(x),ex);
        ey=arrayfun(@(x) samples(x),ex);
        subplot(nm,1,m);
        hold on
        plot(samples)
        errorbar(ex,ey,err,'LineStyle','none');
        hold off
    end
end
