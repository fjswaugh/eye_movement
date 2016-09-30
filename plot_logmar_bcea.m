function plot_logmar_bcea(data)
    figure;
    scatter(data.logmar, data.bcea, 'x');
    title('LogMAR vs. BCEA');
    xlabel('LogMAR')
    ylabel('BCEA')
end
