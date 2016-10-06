function filename = bmp_filename(data, trial_num, dir_name)
    meta = data.meta;
    
    logmar = data.trial(trial_num).logmar;
    logmar_str = num2str(logmar);
    logmar_str = logmar_str(1:6);
    
    letter = data.trial(trial_num).image_char;
    
    lum_str = num2str(meta.luminance);
    if strcmp(lum_str, '0'); lum_str = 'CM'; end;
    
    list = dir([dir_name,   '/Target*',...
                meta.flank, '*',...
                logmar_str, '*',...
                letter,     '*',...
                meta.color, '*',...
                lum_str,    '*']);

    if isempty(list)
        filename = [dir_name, '/not_found.BMP'];
    elseif length(list) ~= 1
        error('Multiple possible image files found');
    else
        filename = [dir_name, '/', list.name];
    end
end
