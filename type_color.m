function rgb = type_color(type)
    if type == -3
        rgb = [1 0 0];  % Red (correct catch)
    elseif type == -2
        rgb = [0 0 1];  % Blue (correct reversal)
    elseif type == -1
        rgb = [0 1 0];  % Green (correct)
    elseif type == 1
        rgb = [1 1 0];  % Yellow (incorrect)
    elseif type == 2
        rgb = [0 1 1];  % Cyan (incorrect reversal)
    elseif type == 3
        rgb = [1 0 1];  % Magenta (incorrect catch)
    else
        rgb = '';
    end
end