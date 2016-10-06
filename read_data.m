function data = read_data(em_filename, ps_filename, screen_res)
    % ----- EM data ----- %
    
    em_file = fopen(em_filename, 'r');
    em_data = cell(0, 1);
    
    % Offset of x and y pixel positions from actual pixel positions on the
    % screen (will be useful for lining up eye movement data to a background
    % image)
    offset = [0, 0];
    
    line = fgetl(em_file);
    while ischar(line)
        if str_contains(line, 'POINT 0')
            % This should be the line containing offset calibration data
            tmp = textscan(line, '%s');
            tmp = textscan(tmp{1}{13}, '%f,%f');
            offset = [tmp{1}, tmp{2}];
        elseif str_contains(line, 'TRIALID')
            % Here we are getting close to the data for a trial, so we read
            % what the trial number is and collect data using
            % get_next_em_data()
            tmp = textscan(line, '%s');
            trial_num_str = tmp{1}{4};
            trial_num = str2num(trial_num_str);

            raw_data = get_next_em_data(em_file);
            data = EyeMovementData(trial_num, raw_data, screen_res, offset);

            em_data{end+1, 1} = data;
        end
        
        % Get next line of file before re-entering loop
        line = fgetl(em_file);
    end
    
    if offset == [0, 0]
        warning('No offset found');
    end

    % ------ PS data ----- %
    
    ps_file = fopen(ps_filename, 'r');
    raw_ps_data = get_ps_data(ps_file);
    
    % ----- Meta data ----- %
    
    % Reopen file so that fgetl() reads lines from the top
    ps_file = fopen(ps_filename, 'r');
    meta = get_meta(ps_file);
    
    % ----- Save everything in memory ----- %
    
    data = Data(raw_ps_data, em_data, meta);
end

function [raw_data] = get_next_em_data(file)
    % Use a cell array to store data because it grows much faster than a
    % matrix. We will then convert the array to a matrix after it's full.
    cell_array = cell(0, 1);

    % State variables, all three must be true to collect data.
    eye_open = true;
    fixed = false;
    synctime_found = false;

    line = fgetl(file);
    while not(str_contains(line, 'END'))
        if str_contains(line, 'SYNCTIME')
            synctime_found = true;
        elseif str_contains(line, 'SFIX')
            fixed = true;
        elseif str_contains(line, 'EFIX')
            fixed = false;
        elseif str_contains(line, 'SBLINK')
            eye_open = false;
        elseif str_contains(line, 'EBLINK')
            eye_open = true;
        % All legitimate data lines end in ... (so test this to make sure)
        elseif str_contains(line, '...')
            if synctime_found && fixed && eye_open
                cell_array{end+1, 1} = cell2mat(textscan(line, '%f', 6))';
            end
        end

        line = fgetl(file);
    end

    % Finally convert the cell array to a matrix.
    raw_data = cell2mat(cell_array);
end

function [raw_data] = get_ps_data(file)
    collect_data = false;
    trial_num = 1;
    cell_array = cell(0, 1);
    
    line = fgetl(file);
    while ischar(line)
        if collect_data
            cell_array{end+1, 1} = cell2mat(textscan(line, '%f', 6))';
            trial_num = trial_num + 1;
        elseif str_contains(line, 'Reversals')
            collect_data = true;
            fgetl(file);
        end
        
        line = fgetl(file);
    end

    raw_data = cell2mat(cell_array);
end

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

function [found] = str_contains(string, search_text)
    found = not(isempty(strfind(string, search_text)));
end
