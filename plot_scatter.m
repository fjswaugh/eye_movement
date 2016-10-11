function figure_num = plot_scatter(em_data, add_as_series, figure_num)
    persistent num;
    
    if nargin == 3
        num = figure_num;
    elseif not(add_as_series) || isempty(num) || not(ishandle(num))
        num = figure();
    end
    
    figure(num);
    
    if add_as_series; hold on; end
    plot(em_data.xdeg, em_data.ydeg, 's',...
         'DisplayName', ['Trial ', num2str(em_data.trial_num)]);
    legend('-DynamicLegend', 2);
    if add_as_series; hold off; end

    xlabel('x (degrees)');
    ylabel('y (degrees)');
    title('Positions of eye fixation');
    
    figure_num = num;
end