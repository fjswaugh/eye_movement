function [] = print_gif(data)
    progression = real(bcea_progression(data.xdeg(), data.ydeg(), 3));

    mpf = 25;  % Milliseconds per frame
    num = figure();
        
    filename = [num2str(data.trial_num()), '.gif'];

    xdeg = data.xdeg();
    ydeg = data.ydeg();

    scalar_size = size(xdeg, 1);

    xdegav = zeros(floor(scalar_size/mpf), 1);
    ydegav = zeros(floor(scalar_size/mpf), 1);

    f = 1;  % Frame number
    while f * mpf <= scalar_size
        start = f * mpf - mpf + 1;
        finish = f * mpf;
        xdegav(f) = mean(xdeg(start:finish));
        ydegav(f) = mean(ydeg(start:finish));

        figure(num)

        subplot(2,1,1);
        plot(xdegav, ydegav, 's');
        str = sprintf(['Average positions of eye fixation through time '...
                       '(trial %d)'], data.trial_num());
        title(str);
        xlabel('x (degrees)');
        ylabel('y (degrees)');
        axis([min(xdeg) max(xdeg) min(ydeg) max(ydeg)]);

        subplot(2,1,2);
        plot(progression(1:finish));
        title('BCEA progression over time');
        xlabel('Time (ms)');
        ylabel('BCEA (whatever units BCEA are in)');
        time = data.time();
        axis([time(1)          time(end)...
              min(progression) max(progression)]);

        drawnow

        frame = getframe(num);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);
        if f == 1;
            imwrite(imind, cm, filename, 'gif', 'Loopcount', inf);
        else
            imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append');
        end

        f = f+1;
    end
end
