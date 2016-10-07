function plot_background(em_data, background_filename)
%plot_background Plots a scatter graph overlayed onto a background image

    background = imread(background_filename);

    figure;

    x = em_data.xpix;
    y = em_data.ypix;

    imagesc([1 1600], [1 1200], flipud(background));

    hold on;
    plot(x, y, 'x');
    set(gca, 'ydir', 'normal');
    
    xlabel('x (pixels)');
    ylabel('y (pixels)');
    str = sprintf('Positions of eye fixation (trial %d)',...
                  em_data.trial_num);
    title(str);
    
    hold off;
end
