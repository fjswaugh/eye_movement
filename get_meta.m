function [meta] = get_meta(file)
    meta = struct('flank', 'Iso', 'color', 'Black', 'luminance', 0);
    
    line = fgetl(file);
    while ischar(line)
        if str_contains(line, 'features')
            txt = textscan(line, '%s', 5);
            txt = txt{1}{5};
            if strcmp(txt, 'Cambridge')
                meta.flank = 'Similar';
            elseif strcmp(txt, 'a')
                meta.flank = 'Box';
            elseif strcmp(txt, 'bars')
                meta.flank = 'Bars';
            end
        elseif str_contains(line, 'luminance')
            txt = textscan(line, '%s', 5);
            txt = txt{1}{5};
            txt = txt(1:length(txt)-1);
            meta.luminance = str2num(txt);
        elseif str_contains(line, 'crowding colour')
            txt = textscan(line, '%s', 6);
            color = [str2num(txt{1}{4}),...
                     str2num(txt{1}{5}),...
                     str2num(txt{1}{6})];
            if color(1) == -254
                meta.color = 'Red';
            elseif color(2) == -254;
                meta.color = 'Green';
            elseif color(3) == -254;
                meta.color = 'Blue';
            end
        end
        
        line = fgetl(file);
    end
end
