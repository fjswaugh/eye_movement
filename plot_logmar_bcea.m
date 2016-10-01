function plot_logmar_bcea(data)
    ax1 = axes('Position',[.75 0 .25 1],'Visible','off');
    ax2 = axes('Position',[.1 .1 .6 .8]);

    hold on;
    x = data.logmar;
    y = data.bcea;
    
    axes(ax2);
    
    % Plot the fit first
    format long
    p = polyfit(x, y, 1);
    yfit = polyval(p, x);
    yresid = y - yfit;
    SSresid = sum(yresid .^ 2);
    SStotal = (length(y)-1) * var(y);
    rsq = 1 - SSresid/SStotal;  % Standard R^2 value
    
    fit_str = sprintf('Fit: y = %.4f*x + %.4f, R^2 = %.4f', p(1), p(2), rsq);
    plot(x, yfit, 'DisplayName', fit_str);
    l = legend('-DynamicLegend');
    l.Location =  'southoutside';
    
    % Now plot the points
    scatter(x, y, 20, data.type_color(), 'filled');
    
    % Now plot legend explaining colors
    axes(ax1);
    for i = [1, -1, 3, -3, 2, -2]  % Least interesting to most interesting
        if i == 0; continue; end;
        xx = x(data.type == i);
        yy = y(data.type == i);
        if isempty(xx); continue; end;
        
        % Now add label for point, because the legend is broken
        points_str = sprintf('• %s', type_str(i));
        ypos = i * 0.1 + 1;
        if ypos > 1; ypos = ypos - 0.1; end;
        t = text(.025, ypos*0.5, points_str);
        t.Color = type_color(i);
        t.FontSize = 9;
    end
    
    hold off;
    
    axes(ax2);
    title('LogMAR vs. BCEA');
    xlabel('LogMAR')
    ylabel('BCEA')
end
