function [data] = get_ps_data(file)
    collect_data = false;
    trial_num = 1;
    cell_array = {};
    
    line = fgetl(file);
    while ischar(line)
        if collect_data
            cell_array(trial_num) = {cell2mat(textscan(line, '%f', 6))};
            trial_num = trial_num + 1;
        elseif str_contains(line, 'Reversals')
            collect_data = true;
            fgetl(file);
        end
        
        line = fgetl(file);
    end
    
    data = cell2mat(cell_array)';
end
