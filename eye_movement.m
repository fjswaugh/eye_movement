% [a, b] = uigetfile('*.*', 'Select eye movement data file');
% em_filename = [b, a];
em_filename = '../eye_movement.asc';
% [a, b] = uigetfile('*.*', 'Select psychophysics data file');
% ps_filename = [b, a];
ps_filename = '../psychophysics.txt';

screen_res = [1600, 1200];

% Read data from em file
em_file = fopen(em_filename, 'r');
line = fgetl(em_file);
count = 0;
offset = [0, 0];
while ischar(line)
    if str_contains(line, 'POINT 0')
        tmp = textscan(line, '%s');
        tmp = textscan(tmp{1}{13}, '%f,%f');
        offset = [tmp{1}, tmp{2}];
    elseif str_contains(line, 'TRIALID')
        tmp = textscan(line, '%s');
        trial_num_str = tmp{1}{4};
        trial_num = str2num(trial_num_str);

        raw_data = get_next_em_data(em_file);
        data = EyeMovementData(trial_num, raw_data, screen_res, offset);

        count = count + 1;
        em_data(count) = data;
    end
    
    line = fgetl(em_file);
end

% Read data from ps file
ps_file = fopen(ps_filename, 'r');
raw_ps_data = get_ps_data(ps_file);

ps_file = fopen(ps_filename, 'r');
meta = get_meta(ps_file);

% Save everything in data object
all_data = Data(raw_ps_data, em_data, count, meta);

% Save selected data as well (4 reverses and 2 controls)
desirable_data = all_data.desirable_data();

