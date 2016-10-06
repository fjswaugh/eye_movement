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
