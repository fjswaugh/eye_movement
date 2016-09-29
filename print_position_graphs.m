function [] = print_position_graphs(data)
    figure
    
    plot(data.xdeg(), data.ydeg(), 's');
    xlabel('x (degrees)');
    ylabel('y (degrees)');
    str = sprintf('Positions of eye fixation (trial %d)', data.trial_num());
    title(str);
    
    figure
    plot(data.time(), [data.xdeg(), data.ydeg()]);
    str = sprintf('X and Y position over time (trial %d)',...
                  data.trial_num());
    title(str);
    xlabel('Time (ms)');
    ylabel('Position (degrees)');
    legend('x position', 'y position');
end