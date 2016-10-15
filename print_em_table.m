function print_em_table(em_data)
%print_em_table Prints a table of eye movement data in a figure
    
    f = figure;
    t = uitable(f);
    
    td = cell(em_data.size(), 6);
    
    td(:, 1) = num2cell(em_data.time);
    td(:, 2) = num2cell(em_data.xpix);
    td(:, 3) = num2cell(em_data.ypix);
    td(:, 4) = num2cell(em_data.xdeg);
    td(:, 5) = num2cell(em_data.ydeg);
    td(:, 6) = num2cell(em_data.pupil_area);
    
    t.Data = td;
    t.ColumnName = {'Time (ms)', 'x (pix)', 'y (pix)',...
                    'x (deg)',   'y (deg)', 'Pupil area'};
    t.ColumnWidth = {120, 120, 120, 120, 120, 120};
    t.Position = [0, 0, 750, 500];
    f.Position = [0, 0, 750, 500];
    t.RowName = [];
end