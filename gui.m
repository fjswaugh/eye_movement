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

% Last Modified by GUIDE v2.5 29-Sep-2016 16:03:47

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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

function em_filename_edit_Callback(hObject, eventdata, handles)
% hObject    handle to em_filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.em_filename = get(hObject, 'String');
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of em_filename_edit as text
%        str2double(get(hObject,'String')) returns contents of em_filename_edit as a double
end

% --- Executes during object creation, after setting all properties.
function em_filename_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to em_filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in browsebutton.
function button_browse_em_Callback(hObject, eventdata, handles)
% hObject    handle to browsebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [a, b] = uigetfile('*.*', 'Select eye movement data file');
    handles.em_filename = [b, a];
    set(handles.em_filename_edit, 'String', handles.em_filename);
    guidata(hObject, handles);
end



function ps_filename_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ps_filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.ps_filename = get(hObject, 'String');
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of ps_filename_edit as text
%        str2double(get(hObject,'String')) returns contents of ps_filename_edit as a double
end

% --- Executes during object creation, after setting all properties.
function ps_filename_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ps_filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in browsebutton.
function button_browse_ps_Callback(hObject, eventdata, handles)
% hObject    handle to browsebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [a, b] = uigetfile('*.*', 'Select psychophysics data file');
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
    length = size(handles.desirable_data.trial_nums, 1);
    summary_data = cell(length, 2);
    summary_data(:, 1) = num2cell(handles.desirable_data.trial_nums);
    for i = 1:length
        summary_data{i, 2} = data_type_str(handles.desirable_data.type(i));
    end
    set(handles.summary_table, 'Data', summary_data);
end
