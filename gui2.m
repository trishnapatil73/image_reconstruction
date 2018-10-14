function varargout = gui2(varargin)
% GUI2 MATLAB code for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 14-Oct-2018 19:30:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2 (see VARARGIN)

% Choose default command line output for gui2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.

function pushbutton1_Callback(hObject, eventdata, handles)%% button for full inverse
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
imshow('watchk1.jpg');   %%% displays image blurred by kernel1 on axes1

A = imread('watch.jpg');  %% read original image
hsv = rgb2hsv(A);   %%% convert it into HSV form
B = hsv(:,:,3);  %%% B is the V plane
F2 = fft2(B);   %% fourier transform of B

[m,n,d] = size(F2);  %% dimensions of image
kernal1 = imread('k1.png');  %% read kernel 1
kernal1 = rgb2hsv(kernal1);   %% convert kernel to hsv
kernal = kernal1(:,:,3);  %%% 'kernel' is V plane of HSV
[x,y,z] = size(kernal);  %% dimensions of kernel

win = fft2(kernal,m,n); %% zero pad kernel to image dimension and take fourier transform

fdomain = F2.*win; %% frequency domain of blurred image
ima = ifft2(fdomain);  %%% Blurred image in spatial domain
img1 = ifftshift(ima);   %%%% in between need to shift

orig = fft2(ima); %% orig is same as 'fdomain'

feat = orig./win; %% reconstructed image in frequency domain
feath = ifft2(feat); %% reconstructed image in spatial domain

feather = mat2gray(feath); %% scaling the values
hsv(:,:,3)= feather; %% making it V plane and merging in hsv
color = hsv2rgb(hsv); %% hsv to rgb
axes(handles.axes2);
imshow(color);  %% show reconstructed image in axes2

PSNR = psnr(feather,B); %% psnr of reconstructed and original image
ssi = ssim(feather,B); %% ssim of reconstructed and original image
set(handles.text13,'string',PSNR); %% display it on gui
set(handles.text14,'string',ssi); %% display it on gui


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles) %% truncated inverse
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
imshow('watchk1.jpg');  %%% displays image blurred by kernel1 on axes1

A = imread('watch.jpg');  %%% displays image blurred by kernel1 on axes1
hsv = rgb2hsv(A);  %% convert image from rgb to hsv
B = hsv(:,:,3); %% seaparate V plane from hsv
F2 = fft2(B); %% Fourier transform of B

[m,n,d] = size(F2); %% dimensions of image
kernal1 = imread('k1.png'); %% read the kernel
kernal1 = rgb2hsv(kernal1); %% convert the kernel from rgb to hsv
kernal = kernal1(:,:,3); %% separate V plane from hsv
[x,y,z] = size(kernal); %% dimensions of kernel

win = fft2(kernal,m,n); %% fourier transform of kernel

fdomain = F2.*win; %% blurred image in frequency domain
ima = ifft2(fdomain); %% blurred image in spatial domain

orig = fft2(ima); %% same as fdomain

feat = orig./win; %% reconstructed image in frequency domain
r = str2double(get(handles.edit1,'string')); %% taking radius as input

h=size(fdomain,1); %%
w=size(fdomain,2); %% dimensions of fdomain
%%% low pass butterworth filter in frequency domain
butterworth = 1./(1+((((h-m/2).^2+(w-n/2).^2).^0.5)./r).^20); 

feat = feat.*butterworth; %% adds cutoff to normal inverse filter
feath = ifft2(feat); %% reconstructed image in spatial domain

feather = mat2gray(feath); %%scaling the values to display the image
hsv(:,:,3)= feather; %% merging V plane back to hsv
color = hsv2rgb(hsv); %% converting hsv to rgb
axes(handles.axes2);
imshow(color);  %% displays image on gui

PSNR = psnr(feather,B); %% calculates psnr
ssi = ssim(feather,B); %% calculates ssi
set(handles.text6,'string',PSNR); %% display psnr
set(handles.text7,'string',ssi); %% display ssi


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
imshow('watchk1.jpg');  %%% displays image blurred by kernel1 on axes1

A = imread('watch.jpg');  %% read original image
hsv = rgb2hsv(A); %% converting image from rgb to hsv
B = hsv(:,:,3); %% separating V plane from hsv
F2 = fft2(B); %% Fourier transform of B

k_val = str2double(get(handles.edit3,'string')); %% take value of K as input

[m,n,d] = size(F2); %% dimensions of image
kernal1 = imread('k1.png'); %% read the kernal
kernal1 = rgb2hsv(kernal1); %% convert the kernel from rgb to hsv
kernal = kernal1(:,:,3);  %% separate V plane from hsv
[x,y,z] = size(kernal); %% dimensions of kernel

win = fft2(kernal,m,n); %% zero padding the kernel and taking fourier transform

fdomain = F2.*win; %% blurred image in frequaency domain
ima = ifft2(fdomain); %% blurred image in spatial domain 
orig = fft2(ima); %% same as fdomian

H = abs(win); %% taking absolute value of kernal in freq domain
feat = fdomain.*(H.^2./(win.*(H.^2+k_val))); %% formula for weiner filter

feath = ifft2(feat); %% reconstructed image (V plane)

feather = mat2gray(feath); %% scaling values of image
hsv(:,:,3)= feather; %% merging V plane in hsv
color = hsv2rgb(hsv); %% convert hsv to rgb
axes(handles.axes2);
imshow(color); %% display final reconstructed image on gui

PSNR = psnr(B,feather); %% calculate psnr
ssi = ssim(B,feather); %% calculate ssi
set(handles.text8,'string',PSNR); %% display psnr
set(handles.text9,'string',ssi); %% display ssi

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles) %% constrained ls filter
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
imshow('watchk1.jpg'); %% display blurred image by kernel 1
g = str2double(get(handles.edit2,'string')); %% take gama value as input 

A = imread('watch.jpg'); %% read the original image
hsv = rgb2hsv(A); %% convert rgb to hsv
B = hsv(:,:,3); %% separate V plane from hsv
F2 = fft2(B); %% fourier transform of B

[m,n,d] = size(F2); %% dimension of image
kernal1 = imread('k1.png'); %% read the kernel
kernal1 = rgb2hsv(kernal1); %% convert the kernel from rgb to hsv
kernal = kernal1(:,:,3); %% separate V plane from hsv
[x,y,z] = size(kernal); %% dimensions of kernel
win = fft2(kernal,m,n); %% zero padding the kernel and converting it into frequency domain

fdomain = F2.*win; %% blurred image in frequency domain

lap = [0 -1 0 ; -1 4 -1 ; 0 -1 0]; %% laplacian operator

lapf = fft2(lap,m,n); %% zero padding laplacian operator 
P = fftshift(lapf); %% fourier transform of laplacian

feat = conj(win).*fdomain./((abs(win).^2)+g*(abs(P)).^2); %% constrained least square formula

ima = ifft2(fdomain);    %%%% ima is blurred image

orig = fft2(ima); %% same as fdomain

feath = (ifft2(feat)); %% reconstructed image

feather = mat2gray(feath); %% scaling the values of image
hsv(:,:,3)= feather; %% merging V plane with hsv
color = hsv2rgb(hsv); %% hsv to rgb
axes(handles.axes2);
imshow((color)); %% display final constructed image on gui

PSNR = psnr(B,feather); %% calculate psnr
ssi = ssim(B,feather); %% calculate ssi

set(handles.text10,'string',PSNR); %% display psnr
set(handles.text11,'string',ssi); %% display ssi


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
