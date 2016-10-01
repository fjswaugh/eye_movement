function filename = bmp_filename(data, trial_num, dir_name)
    meta = data.meta;
    
    logmar = data.logmar_of_trial_num(trial_num);
    logmar_str = num2str(logmar);
    logmar_str = logmar_str(1:6);
    
    letter = data.image_char_of_trial_num(trial_num);
    
    lum_str = num2str(meta.luminance);
    if strcmp(lum_str, '0'); lum_str = 'CM'; end;
    
    list = dir([dir_name,   '/Target*',...
                meta.flank, '*',...
                logmar_str, '*',...
                letter,     '*',...
                meta.color, '*',...
                lum_str,    '*']);
            length(list)

    if length(list) ~= 1
        error('Cannot find image file');
    else
        filename = [dir_name, '/', list.name];
    end
end
