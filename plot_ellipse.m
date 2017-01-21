function plot_ellipse(em_data, k, add_as_series, figure_num)
    persistent num;
    
    set_title = 0;
    if nargin == 4
        num = figure_num;
    elseif not(add_as_series) || isempty(num) || not(ishandle(num))
        num = figure();
        set_title = 1;
    end
    
    figure(num);

    if add_as_series; hold on; end

    s = 2 * k * (1 - pearson(em_data.xdeg, em_data.ydeg)^2)^0.5;
    a = std(em_data.xdeg) * s^0.5;
    b = std(em_data.ydeg) * s^0.5;
    x0 = mean(em_data.xdeg);
    y0 = mean(em_data.ydeg);
    t = -pi:0.01:pi;
    x = x0 + a * cos(t);
    y = y0 + b * sin(t);
    plot(x, y, 'DisplayName',...
         ['Trial ', num2str(em_data.trial_num),...
          ' (k = ', num2str(k), ')']);
    legend('-DynamicLegend', 'Location', 'NorthWest');
    
    if add_as_series; hold off; end
    
    if set_title
        title('Ellipse containing eye movement area');
        xlabel('x (degrees)');
        ylabel('y (degrees)');
    end
end