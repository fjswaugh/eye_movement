% [a, b] = uigetfile('*.*', 'Select eye movement data file');
% em_filename = [b, a];
em_filename = '../eye_movement.asc';
% [a, b] = uigetfile('*.*', 'Select psychophysics data file');
% ps_filename = [b, a];
ps_filename = '../psychophysics.txt';

screen_res = [1600, 1200];

all_data = read_data_from_files(em_filename, ps_filename, screen_res);

% Save selected data as well (4 reverses and 2 controls)
desirable_data = all_data.desirable_data();
