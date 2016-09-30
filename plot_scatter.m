function plot_scatter(data)
    figure
    
    plot(data.xdeg(), data.ydeg(), 's');
    xlabel('x (degrees)');
    ylabel('y (degrees)');
    str = sprintf('Positions of eye fixation (trial %d)', data.trial_num());
    title(str);
end