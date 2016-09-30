function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 30-Sep-2016 13:08:46

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @gui_OpeningFcn, ...
                       'gui_OutputFcn',  @gui_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
% End initialization code - DO NOT EDIT
end


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;

    handles.em_filename = get(handles.em_filename_edit, 'String');
    handles.ps_filename = get(handles.ps_filename_edit, 'String');
    
    handles.trial_num   = str2num(get(handles.trial_num_edit,   'String'));
    handles.start_limit = str2num(get(handles.start_limit_edit, 'String'));
    handles.end_limit   = str2num(get(handles.end_limit_edit,   'String'));

    % Update handles structure
    guidata(hObject, handles);
    
    % Grey input boxes for setting limits
    set(handles.start_limit_edit, 'Enable', 'off');
    set(handles.end_limit_edit,   'Enable', 'off');
    
    % Make everything below invisible so the user can't press anything
    % before data has been loaded
    set(handles.button_table,                     'Visible', 'off');
    set(handles.uipanel1,                         'Visible', 'off');
    set(handles.uibuttongroup1,                   'Visible', 'off');
    set(handles.uibuttongroup2,                   'Visible', 'off');
    set(handles.button_bcea_progression_relevant, 'Visible', 'off');
    
    imshow('logo.png');
end


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;
end

function em_filename_edit_Callback(hObject, eventdata, handles)
    handles.em_filename = get(hObject, 'String');
    guidata(hObject, handles);
end

function em_filename_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function button_browse_em_Callback(hObject, eventdata, handles)
    [a, b] = uigetfile('*.*', 'Select eye movement data file');
    if a == 0; return; end;
    handles.em_filename = [b, a];
    set(handles.em_filename_edit, 'String', handles.em_filename);
    guidata(hObject, handles);
end

function ps_filename_edit_Callback(hObject, eventdata, handles)
    handles.ps_filename = get(hObject, 'String');
    guidata(hObject, handles);
end

function ps_filename_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function button_browse_ps_Callback(hObject, eventdata, handles)
    [a, b] = uigetfile('*.*', 'Select psychophysics data file');
    if a == 0; return; end;
    handles.ps_filename = [b, a];
    set(handles.ps_filename_edit, 'String', handles.ps_filename);
    guidata(hObject, handles);
end

function button_read_data_Callback(hObject, eventdata, handles)    
    screen_res = [1600, 1200];
    
    % Read data from em file
    em_file = fopen(handles.em_filename, 'r');
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
    ps_file = fopen(handles.ps_filename, 'r');
    raw_ps_data = get_ps_data(ps_file);
    
    % Save everything in data object
    handles.all_data = Data(raw_ps_data, em_data, count);
    
    % Save selected data as well (4 reverses and 2 controls)
    handles.desirable_data = handles.all_data.desirable_data();
    
    guidata(hObject, handles);
    
    % Set data in summary table
    summary_data = cell(handles.desirable_data.size(), 2);
    summary_data(:, 1) = num2cell(handles.desirable_data.trial_num);
    summary_data(:, 2) = handles.desirable_data.type_str();
    set(handles.summary_table, 'Data', summary_data);
    
    % Make everything below visible now data is loaded
    set(handles.button_table,                     'Visible', 'on');
    set(handles.uipanel1,                         'Visible', 'on');
    set(handles.uibuttongroup1,                   'Visible', 'on');
    set(handles.uibuttongroup2,                   'Visible', 'on');
    set(handles.button_bcea_progression_relevant, 'Visible', 'on');
end

function button_table_Callback(hObject, eventdata, handles)
    f = figure;
    d = handles.all_data;
    t = uitable(f);
    td = cell(d.size(), 8);
    td(:, 1) = num2cell(d.trial_num);
    td(:, 2) = num2cell(d.logmar);
    td(:, 3) = num2cell(d.image_num);
    td(:, 4) = d.type_str();
    for i = 1:d.size()
        td{i, 5} = std(d.em_data{i}.xdeg());
        td{i, 6} = std(d.em_data{i}.ydeg());
        td{i, 7} = pearson(d.em_data{i}.xdeg(), d.em_data{i}.ydeg());
    end
    td(:, 8) = num2cell(d.bcea);
    
    t.Data = td;
    t.ColumnName = {'Trial',    'LogMAR',  'Image num', 'Type',...
                    'σ(xdeg)',  'σ(ydeg)', 'Pearson',   'BCEA'};
    t.BackgroundColor = ones(d.size(), 3);
    t.BackgroundColor(:, 1) = (-204/255) * d.desirable + 1;
    t.BackgroundColor(:, 2) = (-119/255) * d.desirable + 1;
    t.ColumnWidth = {80, 120, 90, 150, 120, 120, 120, 120};
    t.Position = [0, 0, 960, 600];
end

function trial_num_edit_Callback(hObject, eventdata, handles)
    handles.trial_num = str2num(get(hObject, 'String'));
    guidata(hObject, handles);
end

function trial_num_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function em_scatter_Callback(hObject, eventdata, handles)
    plot_scatter(handles.all_data.em_data_for_trial(handles.trial_num));
end

% --- Executes on button press in button_xy.
function button_xy_Callback(hObject, eventdata, handles)
    plot_xy(handles.all_data.em_data_for_trial(handles.trial_num));
end

% --- Executes on button press in button_hist.
function button_hist_Callback(hObject, eventdata, handles)
    plot_hist(handles.all_data.em_data_for_trial(handles.trial_num));
end

% --- Executes on button press in button_gif.
function button_gif_Callback(hObject, eventdata, handles)
    print_gif(handles.all_data.em_data_for_trial(handles.trial_num));
end


% --- Executes on button press in button_bcea_progression.
function button_bcea_progression_Callback(hObject, eventdata, handles)
    add_as_series = (get(handles.checkbox_progression_add, 'Value') ==...
                     get(handles.checkbox_progression_add, 'Max'));
    plot_bcea_progression(...
            handles.all_data.em_data_for_trial(handles.trial_num),...
            add_as_series);
end

% --- Executes on button press in button_logmar_bcea.
function button_logmar_bcea_Callback(hObject, eventdata, handles)
    if get(handles.radio_all_data, 'Value') ==...
       get(handles.radio_all_data, 'Max')
        d = handles.all_data;
    else
        d = handles.desirable_data;
    end
    
    plot_logmar_bcea(d);
end

% --- Executes on button press in button_bcea_progression_relevant.
function button_bcea_progression_relevant_Callback(hObject, eventdata, handles)
    d = handles.desirable_data;
    figure;
    
    title('BCEA progressions over specified time for relevant trials');
    xlabel('Time (ms)');
    ylabel('BCEA');
        
    hold on;
    for i = 1:d.size()
        progression = real(bcea_progression(d.em_data{i}.xdeg(),...
                                            d.em_data{i}.ydeg(), 3));

        plot(d.em_data{i}.time(), progression,...
             'DisplayName', ['Trial ', num2str(d.em_data{i}.trial_num())])
        legend('-DynamicLegend', 2);
    end
    hold off;
end

function start_limit_edit_Callback(hObject, eventdata, handles)
    handles.start_limit = str2num(get(hObject, 'String'));
    guidata(hObject, handles);
    
    checkbox_limits_Callback(handles.checkbox_limits, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function start_limit_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function end_limit_edit_Callback(hObject, eventdata, handles)
    handles.end_limit = str2num(get(hObject, 'String'));
    guidata(hObject, handles);
    
    checkbox_limits_Callback(handles.checkbox_limits, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function end_limit_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in checkbox_limits.
function checkbox_limits_Callback(hObject, eventdata, handles)
    d = handles.all_data;
    dd = handles.desirable_data;
    if(get(hObject, 'Value') == get(hObject, 'Max'))
        % Ungrey input boxes below
        set(handles.start_limit_edit, 'Enable', 'on');
        set(handles.end_limit_edit,   'Enable', 'on');
        
        d.set_limits(handles.start_limit, handles.end_limit);
        dd.set_limits(handles.start_limit, handles.end_limit);
    else
        % Grey input boxes below
        set(handles.start_limit_edit, 'Enable', 'off');
        set(handles.end_limit_edit,   'Enable', 'off');
        
        d.remove_limits();
        dd.remove_limits();
    end
end
