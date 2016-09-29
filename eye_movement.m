%[a, b] = uigetfile('*.*', 'Select eye movement data file');
em_filename = '../eye_movement.asc';
%[a, b] = uigetfile('*.*', 'Select psychophysics data file');
ps_filename = '../psychophysics.txt';

screen_res = [1600, 1200];

% Read data from em file
em_file = fopen(em_filename, 'r');
line = fgetl(em_file);
count = 0;
while ischar(line)
    if str_contains(line, 'TRIALID')
        tmp = textscan(line, '%s');
        trial_num_str = tmp{1}{4};
        trial_num = str2num(trial_num_str);

        raw_data = get_next_em_data(em_file);
        data = EyeMovementData(trial_num, raw_data, screen_res);

        count = count + 1;
        em_data(count) = data;
    end
    
    line = fgetl(em_file);
end

% Read data from ps file
ps_file = fopen(ps_filename, 'r');
raw_ps_data = get_ps_data(ps_file);

% Save everything in data object
all_data = Data(raw_ps_data, em_data, count);

% Save selected data as well (4 reverses and 2 controls)
desirable_data = all_data.desirable_data();

