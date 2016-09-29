function [data] = get_next_em_data(file)
    % Use a cell array to store data because it grows much faster than a
    % matrix. We will then convert the array to a matrix after it's full.
    cell_array = {};

    % State variables, all three must be true to collect data.
    eye_open = true;
    fixed = false;
    synctime_found = false;

    index = 0;  % An index so that we know where to add data to cell array.
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
                index = index + 1;
                cell_array(index) = {cell2mat(textscan(line, '%f', 6))};
            end
        end

        line = fgetl(file);
    end

    % Finally convert the cell array to a matrix.
    data = cell2mat(cell_array)';
end
