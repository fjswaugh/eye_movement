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

% Last Modified by GUIDE v2.5 15-Oct-2016 20:36:05

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

    handles.em_filename    = get(handles.em_filename_edit,    'String');
    handles.ps_filename    = get(handles.ps_filename_edit,    'String');
    handles.background_dir = get(handles.background_dir_edit, 'String');
    
    handles.trial_nums = read_from_trial_num_edit(handles);

    handles.start_limit = str2num(get(handles.start_limit_edit, 'String'));
    handles.end_limit   = str2num(get(handles.end_limit_edit,   'String'));

    % Update handles structure
    guidata(hObject, handles);
    
    % Grey input boxes for setting limits
    set(handles.start_limit_edit, 'Enable', 'off');
    set(handles.end_limit_edit,   'Enable', 'off');
    
    % Make everything below invisible so the user can't press anything
    % before data has been loaded
    set(handles.panel_data, 'Visible', 'off');
    
    imshow('logo.png');
end

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;
end

% ----- Functions for object creation, after setting properties ----- %

function em_filename_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function ps_filename_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function background_dir_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function end_limit_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function start_limit_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function trial_num_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ----- Callback functions ----- %

function em_filename_edit_Callback(hObject, eventdata, handles)
    handles.em_filename = get(hObject, 'String');
    guidata(hObject, handles);
end

function ps_filename_edit_Callback(hObject, eventdata, handles)
    handles.ps_filename = get(hObject, 'String');
    guidata(hObject, handles);
end

function background_dir_edit_Callback(hObject, eventdata, handles)
    handles.background_dir = get(hObject, 'String');
    guidata(hObject, handles);
end

function button_browse_em_Callback(hObject, eventdata, handles)
    [a, b] = uigetfile('*.*', 'Select eye movement data file');
    if a == 0; return; end;
    handles.em_filename = [b, a];
    set(handles.em_filename_edit, 'String', handles.em_filename);
    guidata(hObject, handles);
end

function button_browse_ps_Callback(hObject, eventdata, handles)
    [a, b] = uigetfile('*.*', 'Select psychophysics data file');
    if a == 0; return; end;
    handles.ps_filename = [b, a];
    set(handles.ps_filename_edit, 'String', handles.ps_filename);
    guidata(hObject, handles);
end

function button_browse_background_Callback(hObject, eventdata, handles)
    tmp = uigetdir('.', 'Select directory containing background image files');
    if tmp == 0; return; end;
    handles.background_dir = tmp;
    set(handles.background_dir_edit, 'String', handles.background_dir);
    guidata(hObject, handles);
end

function button_read_data_Callback(hObject, eventdata, handles)    
    screen_res = [1600, 1200];
    handles.all_data = read_data(handles.em_filename,...
                                 handles.ps_filename,...
                                 screen_res);
    
    % Save selected data as well (4 reverses and 2 controls)
    handles.desirable_data = handles.all_data.desirable_data();
    
    guidata(hObject, handles);
    
    % Make sure to apply any limits that have been selected
    checkbox_limits_Callback(handles.checkbox_limits, eventdata, handles);
    % List of relevant trials will now be different
    checkbox_relevant_trials_Callback(handles.checkbox_relevant_trials,...
                                      eventdata, handles);
    
    % Set data in summary table
    summary_data = cell(handles.desirable_data.size(), 2);
    summary_data(:, 1) = num2cell(handles.desirable_data.trial_num);
    summary_data(:, 2) = handles.desirable_data.type_str();
    set(handles.summary_table, 'Data', summary_data);
    
    % Show meta data
    str = meta_str(handles.all_data.meta);
    str(1) = upper(str(1));
    set(handles.panel_data, 'Title', str);
    
    % Make everything below visible now data is loaded
    set(handles.panel_data, 'Visible', 'on');
    
    % Finally, load a copy of the all_data variable into the workspace
    assignin('base', 'data', handles.all_data.copy);
end

function button_table_Callback(hObject, eventdata, handles)
    print_table(handles.all_data);
end

function button_logmar_bcea_Callback(hObject, eventdata, handles)
    if get(handles.radio_all_data, 'Value') ==...
       get(handles.radio_all_data, 'Max')
        d = handles.all_data;
    else
        d = handles.desirable_data;
    end
    
    plot_logmar_bcea(d);
end

function start_limit_edit_Callback(hObject, eventdata, handles)
    handles.start_limit = str2num(get(hObject, 'String'));
    guidata(hObject, handles);
    
    checkbox_limits_Callback(handles.checkbox_limits, eventdata, handles);
end

function end_limit_edit_Callback(hObject, eventdata, handles)
    handles.end_limit = str2num(get(hObject, 'String'));
    guidata(hObject, handles);
    
    checkbox_limits_Callback(handles.checkbox_limits, eventdata, handles);
end

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

function trial_num_edit_Callback(hObject, eventdata, handles)
    handles.trial_nums = read_from_trial_num_edit(handles);
    guidata(hObject, handles);
end

function checkbox_relevant_trials_Callback(hObject, eventdata, handles)
    if(get(hObject, 'Value') == get(hObject, 'Max'))
        % Grey input box below
        set(handles.trial_num_edit, 'Enable', 'off');
        handles.trial_nums = handles.desirable_data.trial_num;
    else
        % Ungrey input box below
        set(handles.trial_num_edit, 'Enable', 'on');
        handles.trial_nums = read_from_trial_num_edit(handles);
    end
    guidata(hObject, handles);
end

function button_em_table_Callback(hObject, eventdata, handles)
    for i = 1:length(handles.trial_nums)
        index = handles.all_data.index_for_trial(handles.trial_nums(i));
        print_em_table(handles.all_data.em_data{index}.copy());
    end
end

function button_xy_Callback(hObject, eventdata, handles)
    for i = 1:length(handles.trial_nums)
        index = handles.all_data.index_for_trial(handles.trial_nums(i));
        plot_xy(handles.all_data.em_data{index}.copy());
    end
end

function button_hist_Callback(hObject, eventdata, handles)
    for i = 1:length(handles.trial_nums)
        index = handles.all_data.index_for_trial(handles.trial_nums(i));
        plot_hist(handles.all_data.em_data{index}.copy());
    end
end

function button_gif_Callback(hObject, eventdata, handles)
    for i = 1:length(handles.trial_nums)
        trial_num = handles.trial_nums(i);
        
        index = handles.all_data.index_for_trial(trial_num);
        em_data = handles.all_data.em_data{index}.copy();
        
        [a, b] = uiputfile('*.gif',...
                           ['Save .gif for trial ',...
                            num2str(em_data.trial_num), ' as...']);
        if a == 0; continue; end;
        filename = [b, a];
        
        print_gif(em_data, filename);
    end
end

% Generate scatter with relevant background
function button_background_Callback(hObject, eventdata, handles)
    for i = 1:length(handles.trial_nums)
        trial_num = handles.trial_nums(i);
                    
        filename = bmp_filename(handles.all_data,...
                                trial_num,...
                                handles.background_dir);

        choose_image = (get(handles.checkbox_choose_image, 'Value') ==...
                        get(handles.checkbox_choose_image, 'Max'));
        if choose_image
            title_str = sprintf('Select background image for trial %d',...
                                trial_num);
            [a, b] = uigetfile('*.BMP', title_str);
            if a == 0; continue; end;
            filename = [b, a];
        end
        
        index = handles.all_data.index_for_trial(trial_num);
        em_data = handles.all_data.em_data{index}.copy();
        
        xoffset = str2double(get(handles.edit_xoffset, 'String'));
        yoffset = str2double(get(handles.edit_yoffset, 'String'));
        
        em_data.xpix = em_data.xpix + xoffset;
        em_data.ypix = em_data.ypix + yoffset;
        
        plot_background(em_data, filename);
    end
end

function button_scatter_Callback(hObject, eventdata, handles)
    specific_figure = (get(handles.radio_scatter_figure, 'Value') ==...
                       get(handles.radio_scatter_figure, 'Max'));
    
    for i = 1:length(handles.trial_nums)
        index = handles.all_data.index_for_trial(handles.trial_nums(i));
        em_data = handles.all_data.em_data{index}.copy();
        
        if specific_figure
            figure = str2num(get(handles.edit_scatter_figure, 'String'));
            plot_scatter(em_data, 1, figure);
        else
            plot_scatter(em_data, 0);
        end
    end
end

function button_ellipse_Callback(hObject, eventdata, handles)
    specific_figure = (get(handles.radio_ellipse_figure, 'Value') ==...
                       get(handles.radio_ellipse_figure, 'Max'));
                   
    k = str2double(get(handles.edit_scatter_k, 'String'));

    for i = 1:length(handles.trial_nums)
        index = handles.all_data.index_for_trial(handles.trial_nums(i));
        em_data = handles.all_data.em_data{index}.copy();
        
        if specific_figure
            figure = str2num(get(handles.edit_ellipse_figure, 'String'));
            plot_ellipse(em_data, k, 1, figure);
        else
            plot_ellipse(em_data, k, 0);
        end
    end
end

function button_bcea_progression_Callback(hObject, eventdata, handles)
    specific_figure = (get(handles.radio_bcea_figure, 'Value') ==...
                       get(handles.radio_bcea_figure, 'Max'));
                   
    for i = 1:length(handles.trial_nums)
        index = handles.all_data.index_for_trial(handles.trial_nums(i));
        em_data = handles.all_data.em_data{index}.copy();
        
        if specific_figure
            figure = str2num(get(handles.edit_bcea_figure, 'String'));
            plot_bcea_progression(em_data, 1, figure);
        else
            plot_bcea_progression(em_data, 0);
        end
    end
end

function button_pupil_area_Callback(hObject, eventdata, handles)
    specific_figure = (get(handles.radio_pa_figure, 'Value') ==...
                       get(handles.radio_pa_figure, 'Max'));
                   
    for i = 1:length(handles.trial_nums)
        index = handles.all_data.index_for_trial(handles.trial_nums(i));
        em_data = handles.all_data.em_data{index}.copy();
        
        if specific_figure
            figure = str2num(get(handles.edit_pa_figure, 'String'));
            plot_pupil_area(em_data, 1, figure);
        else
            plot_pupil_area(em_data, 0);
        end
    end
end

function edit_scatter_figure_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    set(hObject, 'Enable', 'off');
end

function edit_ellipse_figure_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    set(hObject, 'Enable', 'off');
end

function edit_bcea_figure_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject, 'Enable', 'off');
end

function edit_pa_figure_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject, 'Enable', 'off');
end

function radio_ellipse_figure_Callback(hObject, eventdata, handles)
    set(handles.edit_ellipse_figure, 'Enable', 'on');
end

function radio_scatter_figure_Callback(hObject, eventdata, handles)
    set(handles.edit_scatter_figure, 'Enable', 'on');
end

function radio_ellipse_new_Callback(hObject, eventdata, handles)
    set(handles.edit_ellipse_figure, 'Enable', 'off');
end

function radio_scatter_new_Callback(hObject, eventdata, handles)
    set(handles.edit_scatter_figure, 'Enable', 'off');
end

function radio_pa_figure_Callback(hObject, eventdata, handles)
    set(handles.edit_pa_figure, 'Enable', 'on');
end

function radio_pa_new_Callback(hObject, eventdata, handles)
    set(handles.edit_pa_figure, 'Enable', 'off');
end

function radio_bcea_new_Callback(hObject, eventdata, handles)
    set(handles.edit_bcea_figure, 'Enable', 'off');
end

function radio_bcea_figure_Callback(hObject, eventdata, handles)
    set(handles.edit_bcea_figure, 'Enable', 'on');
end

% ----- Other helper functions ----- %

function trial_nums = read_from_trial_num_edit(handles)
    c = textscan(get(handles.trial_num_edit, 'String'), '%d');
    trial_nums = c{1};
end
