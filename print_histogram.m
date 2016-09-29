function [] = print_histogram(data)
    figure
    histogram2(data.xdeg(), data.ydeg(), 50, 'FaceColor', 'flat')
    str = sprintf('Histogram of eye position data (trial %d)',...
                  data.trial_num());
    title(str);
    xlabel('x (degrees)')
    ylabel('y (degrees)')
end