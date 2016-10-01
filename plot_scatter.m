function plot_scatter(em_data, add_as_series)
    persistent num;
    if not(add_as_series) || isempty(num) || not(ishandle(num))
        num = figure();
    end
    
    figure(num);
    
    if add_as_series; hold on; end
    plot(em_data.xdeg(), em_data.ydeg(), 's',...
         'DisplayName', ['Trial ', num2str(em_data.trial_num())]);
    legend('-DynamicLegend', 2);
    if add_as_series; hold off; end

    xlabel('x (degrees)');
    ylabel('y (degrees)');
    str = sprintf('Positions of eye fixation (trial %d)', em_data.trial_num());
    title(str);
end