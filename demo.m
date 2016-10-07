%% Preliminaries

% Select the filenames for the data
em_filename = '../eye_movement.asc';
ps_filename = '../psychophysics.txt';

% Enter the screen resolution
screen_res = [1600, 1200];

% Read in the data from the filenames given, using the screen_res selected
data = read_data(em_filename, ps_filename, screen_res);

%% View how the data is structured

disp(data);

%%

% You can access any part of the data with the 'dot' syntax, e.g.
data.logmar

%%

% Each data point has associated with it a:
%  - trial number
%  - logmar
%  - type (is the trial a reversal, catch, etc.)
%  - desirable boolean (is the trial one of the six interesting ones)
%  - image_char (the letter that was being identified)
%  - em_data (an object containing fixed eye movement data for the trial)

% To access any datum for one particular trial, the trial() method can be
% used. The following line will therefore print out all the data for trial
% number 5 (which may or may not be the 5th row of the data).
data.trial(5)

%%

% From here, we could examine, say, the 'type' of trial 5
data.trial(5).type

%%

% This isn't particularly informative. Luckily there is a function to
% translate this number into a helpful string.
% The result of this function will be one of six possibilities:
%  - 'Correct reversal'
%  - 'Correct reversal'
%  - 'Correct'
%  - 'Incorrect'
%  - 'Incorrect reversal'
%  - 'Incorrect catch' (an unusual result, given the size of catch trials)
type_str(data.trial(5).type)

%%

% Before moving on to eye movement data, this is how to select the six
% particularly desirable data points from all of the data. Notice that this
% has made a copy of 'data', but removed all but six points. It can be
% handled in exactly the same way as the previous 'data' variable.
desirable_data = data.desirable_data()

%% Eye movement data

% Let's look at trial 5 again, this time picking out the eye movement data
% associated with it. I'll save this in a new variable, so we don't have to
% keep typing out data.trial(5).em_data all the time.
em = data.trial(5).em_data;

% Now we could, say, calculate the BCEA for this trial
% The bcea function takes arguments in the form bcea(x data, y data, k)
bcea(em.xdeg, em.ydeg, 3)

%%

% Perhaps now though we want to look only at a certain time period in the
% data, for example for time 101ms -> 300ms
em.set_limits(101, 300);

% Now the eye movement data is different, with only 200 data points)
em

%%

% The bcea is also different:
bcea(em.xdeg, em.ydeg, 3)

%%

% Note that the extra data points for time not equal to 101->300ms is still
% there. The size() method will give the original size of the data...
em.size()

%%

% ...and the limits can also be easily removed to look at the whole time
% period again.
em.remove_limits();

%%

% There are also functions to calculate Pearson's cofficient, standard
% deviations of x and y data, and a function that returns an array showing
% how the BCEA value progresses over time.
pearsons_coefficient       = pearson(em.xdeg, em.ydeg);
standard_deviation_of_xdeg = std(em.xdeg);
array_of_bcea_progression  = bcea_progression(em.xdeg, em.ydeg, 3);

%% Meta data

% Going back to the object containing all the data from this file, there is
% another field as yet unexplained - data.meta. It contains info extracted
% from the psychophysics file and uniquely identifies the experimental run.
data.meta

%% How to plot graphs with the data

