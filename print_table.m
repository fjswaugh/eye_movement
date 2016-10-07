function print_table(data)
%print_table Prints a table of the data in a figure
    
    f = figure;
    t = uitable(f);
    
    td = cell(data.size(), 8);
    
    td(:, 1) = num2cell(data.trial_num);
    td(:, 2) = num2cell(data.logmar);
    td(:, 3) = cellstr(data.image_char);
    td(:, 4) = data.type_str();
    for i = 1:data.size()
        td{i, 5} = std(data.em_data{i}.xdeg);
        td{i, 6} = std(data.em_data{i}.ydeg);
        td{i, 7} = pearson(data.em_data{i}.xdeg, data.em_data{i}.ydeg);
    end
    td(:, 8) = num2cell(data.bcea);
    
    t.Data = td;
    t.ColumnName = {'Trial',    'LogMAR',  'Image char', 'Type',...
                    'σ(xdeg)',  'σ(ydeg)', 'Pearson',    'BCEA'};
    t.BackgroundColor = ones(data.size(), 3);
    t.BackgroundColor(:, 1) = (-204/255) * data.desirable + 1;
    t.BackgroundColor(:, 2) = (-119/255) * data.desirable + 1;
    t.ColumnWidth = {80, 120, 90, 150, 120, 120, 120, 120};
    t.Position = [0, 0, 960, 600];
    t.RowName = [];
end
