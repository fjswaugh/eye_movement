function plot_xy(em_data)
    figure
    plot(em_data.time(), [em_data.xdeg(), em_data.ydeg()]);
    str = sprintf('X and Y position over time (trial %d)',...
                  em_data.trial_num());
    title(str);
    xlabel('Time (ms)');
    ylabel('Position (degrees)');
    legend('x position', 'y position');
end
