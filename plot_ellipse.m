function plot_ellipse(em_data, k, figure_num)
    figure(figure_num);
    hold on;
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
    legend('-DynamicLegend', 2);
    hold off;
end