% compare_detect is used compare the effect of selected
% low/high/bandpass filters in QRS detection accuracy
% using plot
%
function compare_detect(samples, params, filter_funcs)
    % height of the vertical R indicators
    err_bar_height = 0.1 * (max(samples(1:1000)) - min(samples(1:1000)));

    err = [];

    % number of filter functions
    nm = length(filter_funcs);

    % make a plot for each filter function
    for m = 1:nm
        % perform the QRS detection using filter function m
        % ex will contain Each R index in the samples array
        ex = qrs_detect3_(samples, params, filter_funcs{m});

        % calculate the correspoding y value by a simple lookup in samples array
        ey = arrayfun(@(x) samples(x), ex);

        % create array with height of the error indicators
        err = err_bar_height * ones(length(ex), 1);

        % plot samples and R indicators
        subplot(nm, 1, m);
        hold on
        plot(samples)
        errorbar(ex, ey, err, 'LineStyle', 'none');
        hold off
    end

end
