function [] = plot_bcea_progression(em_data, add_as_series)
    persistent num;
    if not(add_as_series) || isempty(num) || not(ishandle(num))
        num = figure();
    end
    
    figure(num);
    
    progression = real(bcea_progression(em_data.xdeg, em_data.ydeg, 3));

    if add_as_series; hold on; end
    plot(em_data.time, progression,...
         'DisplayName', ['Trial ', num2str(em_data.trial_num)])
    legend('-DynamicLegend', 2);
    if add_as_series; hold off; end
    
    title('BCEA progression over specified time');
    xlabel('Time (ms)');
    ylabel('BCEA');
end