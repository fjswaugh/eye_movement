function [] = print_bcea_progression(data, add_as_series)
    persistent num;
    if not(add_as_series) || isempty(num) || not(ishandle(num))
        num = figure();
    end
    
    figure(num);
    
    progression = real(bcea_progression(data.xdeg(), data.ydeg(), 3));

    if add_as_series; hold on; end
    plot(data.time(), progression,...
         'DisplayName', ['Trial ', num2str(data.trial_num())])
    legend('-DynamicLegend', 2);
    if add_as_series; hold off; end
    
    title('BCEA progressions over specified time for different trials');
    xlabel('Time (ms)');
    ylabel('BCEA (whatever units BCEA is)');
end