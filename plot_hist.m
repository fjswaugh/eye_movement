function [] = plot_hist(em_data)
    figure
    histogram2(em_data.xdeg(), em_data.ydeg(), 50, 'FaceColor', 'flat')
    str = sprintf('Histogram of eye position data (trial %d)',...
                  em_data.trial_num());
    title(str);
    xlabel('x (degrees)')
    ylabel('y (degrees)')
end