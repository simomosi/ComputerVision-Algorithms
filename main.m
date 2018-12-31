function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 23-Aug-2018 11:24:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

clc

global img_original histogram_original img_computed histogram_computed;
global thisFile thisFolder projRoot;

% Variables initialization
img_original=false;
histogram_original=false;
img_computed=false;
histogram_computed=false;

% Paths import
thisFile = mfilename('fullpath');               % Path to 'main.m'
thisFolder = fileparts(thisFile);               % Path to directories
projRoot = fileparts(fileparts(thisFolder));    % Path to root directory
addpath(thisFolder);
addpath(fullfile(thisFolder, 'img')); % Path to image folder
addpath(fullfile(thisFolder, 'noises')); % Path to noise folder
addpath(fullfile(thisFolder, 'filters')); % Path to filter folder
addpath(fullfile(thisFolder, 'detection')); % Path to edge detection's algorithms

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when uipanel2 is resized.
function uipanel2_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in gui_open_btn.
function gui_open_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gui_open_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global img_original histogram_original img_computed histogram_computed thisFolder file;
%     path=fullfile(thisFolder, 'img/wall.jpg');
    [file,user_cancel] = imgetfile('InitialPath', fullfile(thisFolder, 'img'));    
    if user_cancel
        %msgbox(sprintf('ERROR'),'Error','Error');
        return;
    end    
    [img_original,map] = imread(file);
%     [img_original,map] = imread(path);
    if(ndims(img_original) == 3)
        img_original = rgb2gray(img_original);
    end
    img_computed = img_original; 
    
    updateImageGUI(handles.gui_img_original, img_original);    
    computeHistogram(handles.gui_histogram_original, img_original);
    
%     updateImageGUI(handles.gui_img_computed, img_computed);    
%     computeHistogram(handles.gui_histogram_computed, img_computed);    
    img_computed = computeImage(handles, img_original);
    
% --- Executes on button press in gui_reset_btn.
function gui_reset_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gui_reset_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global img_original img_computed 
    set(handles.gui_popup_noise, 'Value', 1);
    set(handles.gui_popup_filter, 'Value', 1);
    set(handles.gui_popup_detection, 'Value', 1);
    set(handles.gui_negative_btn, 'Value', 0);
    set(handles.gui_repeat_filter, 'String', '1');
    img_computed = computeImage(handles, img_original);

% --- Executes on button press in gui_negative_btn.
function gui_negative_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gui_negative_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global img_computed img_original
    img_computed = computeImage(handles, img_original);


% --- Executes on button press in gui_save_btn.
function gui_save_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gui_save_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global img_computed thisFolder
    if not(img_computed)
        msgbox(sprintf('No image selected!'),'Error','Error');
        img_computed = false;
        return;
    end
    % Save image with a new name.
    name=strcat(datestr(now,'HH-MM-SS-FFF'),'.jpg');
    path=fullfile(thisFolder, 'img',name);
    imwrite(img_computed,path);
    msgbox(strcat('Image saved as ',' ',name));


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gui_popup_noise.
function gui_popup_noise_Callback(hObject, eventdata, handles)
% hObject    handle to gui_popup_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns gui_popup_noise contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gui_popup_noise
    global img_computed img_original
    img_computed = computeImage(handles, img_original);

% --- Executes during object creation, after setting all properties.
function gui_popup_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gui_popup_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gui_popup_filter.
function gui_popup_filter_Callback(hObject, eventdata, handles)
% hObject    handle to gui_popup_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global img_computed img_original
    img_computed = computeImage(handles, img_original);

% Hints: contents = cellstr(get(hObject,'String')) returns gui_popup_filter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gui_popup_filter


% --- Executes during object creation, after setting all properties.
function gui_popup_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gui_popup_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gui_popup_detection.
function gui_popup_detection_Callback(hObject, eventdata, handles)
% hObject    handle to gui_popup_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global img_computed img_original
    img_computed = computeImage(handles, img_original);

% Hints: contents = cellstr(get(hObject,'String')) returns gui_popup_detection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gui_popup_detection


% --- Executes during object creation, after setting all properties.
function gui_popup_detection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gui_popup_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function gui_img_original_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to gui_img_original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in gui_hough_btn.
function gui_hough_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gui_hough_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function gui_edge_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to gui_edge_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    str=get(hObject,'String');
    if isnan(str2double(str))
        set(hObject,'string','20');
        warndlg('Threshold not valid. Set to default value.');
        return;
    end
%     global img_computed img_original
%     img_computed = computeImage(handles, img_original);

% Hints: get(hObject,'String') returns contents of gui_edge_threshold as text
%        str2double(get(hObject,'String')) returns contents of gui_edge_threshold as a double


% --- Executes during object creation, after setting all properties.
function gui_edge_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gui_edge_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gui_apply_btn.
function gui_apply_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gui_apply_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global img_computed img_original
    img_computed = computeImage(handles, img_original);


% --- Executes on key press with focus on gui_edge_threshold and none of its controls.
function gui_edge_threshold_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to gui_edge_threshold (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    str=get(hObject,'String');
    if isnan(str2double(str))
        set(hObject,'string','20');
        warndlg('Threshold not valid. Set to default value.');
    end



function gui_repeat_filter_Callback(hObject, eventdata, handles)
% hObject    handle to gui_repeat_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gui_repeat_filter as text
%        str2double(get(hObject,'String')) returns contents of gui_repeat_filter as a double


% --- Executes during object creation, after setting all properties.
function gui_repeat_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gui_repeat_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on gui_repeat_filter and none of its controls.
function gui_repeat_filter_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to gui_repeat_filter (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    str=get(hObject,'String');
    if isnan(str2double(str)) || str2double(str)<1
        set(hObject,'string','1');
        warndlg('Value not valid. Set to default value.');
    end


% --- Executes on button press in gui_tomasi_btn.
function gui_tomasi_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gui_tomasi_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global img_original
    if not(img_original)
        msgbox(sprintf('No image selected!'),'Error','Error');
        return;
    end
    % Mask 3x3
    kanade_img = tomasiKanade(img_original, 3);
    figure('Name','Measured Data','NumberTitle','off');
    imshow(kanade_img, [])
