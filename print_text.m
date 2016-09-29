function [] = print_text(logmar, data)
    fprintf('\n');
    fprintf('Trial number: %d\n', data.trial_num());
    fprintf('LogMAR:               %f\n', logmar);
    fprintf('σ(xdeg), σ(ydeg):     %f, %f\n', std(data.xdeg()),...
                                              std(data.ydeg()));
    fprintf('Pearsons correlation: %f\n', pearson(data.xdeg(), data.ydeg()));
    fprintf('BCEA:                 %f\n', bcea(data.xdeg(), data.ydeg(), 3));
    fprintf('\n');
end