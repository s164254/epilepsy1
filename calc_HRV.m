function [HRV] = calc_HRV(qrs_index,params)

%Calculate HRV by using qrs indices.
HRV=diff(qrs_index)/params.sf;

end

