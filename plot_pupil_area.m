function plot_pupil_area(em_data, add_as_series, figure_num)
    persistent num;
    
    if nargin == 3
        num = figure_num;
    elseif not(add_as_series) || isempty(num) || not(ishandle(num))
        num = figure();
    end
    
    figure(num);
    
    if add_as_series; hold on; end
    plot(em_data.time, em_data.pupil_area,...
         'DisplayName', ['Trial ', num2str(em_data.trial_num)])
    legend('-DynamicLegend', 2);
    if add_as_series; hold off; end
    
    title('Pupil area over specified time');
    xlabel('Time (ms)');
    ylabel('Pupil area');
end