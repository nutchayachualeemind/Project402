function varargout = rate_gui(varargin)
% RATE_GUI MATLAB code for rate_gui.fig
%      RATE_GUI, by itself, creates a new RATE_GUI or raises the existing
%      singleton*.
%
%      H = RATE_GUI returns the handle to a new RATE_GUI or the handle to
%      the existing singleton*.
%
%      RATE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RATE_GUI.M with the given input arguments.
%
%      RATE_GUI('Property','Value',...) creates a new RATE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rate_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rate_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rate_gui

% Last Modified by GUIDE v2.5 12-Feb-2018 20:17:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rate_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @rate_gui_OutputFcn, ...
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


% --- Executes just before rate_gui is made visible.
function rate_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rate_gui (see VARARGIN)

% Choose default command line output for rate_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rate_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rate_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename_v
[chosenfile, chosenpath] = uigetfile('*.wav', 'Select a video');
  if ~ischar(chosenfile)
    return;   %user canceled dialog
  end
  
  filename_v = fullfile(chosenpath, chosenfile);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename_a
[chosenfile, chosenpath] = uigetfile('*.mp3', 'Select a video');
  if ~ischar(chosenfile)
    return;   %user canceled dialog
  end
  
  filename_a = fullfile(chosenpath, chosenfile);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename_v
global total_skin1
% Read video
xyloObj = VideoReader(filename_v);
get(xyloObj)
nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

resX = vidHeight;
resY = vidWidth;

position = [23 373;35 185]; 
box_color = {'red','green'};
%%
count_frame = 0;
oldPoints = [];
mov(1:nFrames) = ...
    struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),'colormap',[]);
for k = 5000 : nFrames %k = 15200 : 16000
    mov(k).cdata = read(xyloObj,k);
    rgb_im = mov(k).cdata;
    %%
    img = rgb_im; %ayyildiz-20501-yesil-desenli-bikini-1991-11-B
    axes(handles.axes1)
    imshow(img)
    %% ycbcr
    ycbcr_im = rgb2ycbcr(img);
%     figure, imshow(ycbcr_im)
    %% thresholds 1.	กำหนดค่าสีผิวเพื่อแยกพิกเซลที่เป็นสีผิวออกจากพิกเซลที่ไม่ใช่สีผิว
    y = ycbcr_im(:,:,1);
    cb = ycbcr_im(:,:,2);
    cr = ycbcr_im(:,:,3);
    [rycbcr cycbcr] = size(y);
    out_ycbcr = y;
    for iycbcr = 1:rycbcr
        for jycbcr = 1:cycbcr
            if y(iycbcr,jycbcr) >= 80 && cb(iycbcr,jycbcr) >= 77 && cb(iycbcr,jycbcr) <= 135 && cr(iycbcr,jycbcr) >= 133 && cr(iycbcr,jycbcr) <= 173
    %         if y(iycbcr,jycbcr) >= ymin-5 && y(iycbcr,jycbcr) <= ymax+20 && cb(iycbcr,jycbcr) >= cbmin-25 && cb(iycbcr,jycbcr) <= cbmax && cr(iycbcr,jycbcr) >= crmin && cr(iycbcr,jycbcr) <= crmax+25
                out_ycbcr(iycbcr,jycbcr) = 255;
            else
                out_ycbcr(iycbcr,jycbcr) = 0;
            end
        end
    end
    out_ycbcr = im2bw(out_ycbcr);
    total_skin = sum(sum(out_ycbcr));
    total_skin1(k,:) = total_skin;
    % out_ycbcr = imfill(out_ycbcr, 'holes');
    %%
    % 2.	คำนาณคำนวณเปอร์เซ็นต์ของพิกเซลผิวเทียบกับขนาดของภาพ (skin percentage)
    % 3.	ระบุพิกเซลผิวที่เชื่อมต่อกันเพื่อสร้างบริเวณผิวและคำนวณจำนวนพื้นที่ผิว
    % 4.	ระบุพิกเซลที่เป็นของผิวที่ใหญ่ที่สุดสามregions 

    BW2 = bwareafilt(out_ycbcr,3);
    %figure, imshow(BW2), title('out_ycbcr'), impixelinfo  
    axes(handles.axes2)
    imshow(BW2)
    %% 5.	ระบุด้านซ้ายสุด บนสุด(upper) ด้านขวาสุดและพิกเซลผิวด้านล่างสุดของสามผิวที่ใหญ่ที่สุดสร้างรูปหลายเหลี่ยมขึ้นมา
    labeledImage = bwlabel( BW2);
    measurements = regionprops(labeledImage, 'BoundingBox', 'Area');
%     for kk = 1 : length(measurements)
%       thisBB = round(measurements(k).BoundingBox);
%       thisBB = thisBB-2;
%       thisBB1(k,:) = thisBB;
%       rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
%       'EdgeColor','r','LineWidth',2 )
    %%
    % 6.	คำนวณพื้นที่และคำนวณพิกเซลผิวในรูปหลายเหลี่ยมเพื่อหา skin percentage  ของแต่ละจุด
    % 7.	ถ้าเปอร์เซ็นต์ของผิวพิกเซลสัมพันธ์กับขนาดภาพ <  15 % = not nude

%     cut = out_ycbcr(thisBB(2):thisBB(4)+thisBB(2),thisBB(1):thisBB(3)); % ตัดแต่ละส่วน
    %figure, imshow(cut)
    amount_skin = sum(sum(out_ycbcr));
    
%     if amount_skin == 0
%     amount_skin = 1;
%     precent_skin = (amount_skin/total_skin) * 100;
%     precent_skin_array(k,:) = precent_skin;
    %%
    % 8.	ถ้าจำนวน number of skin pixels in the largest skin region is less than 35% 
    %of the total skin count, the number of skin pixels in the second largest region 
    %is less than 30% of the total skin count and the number of skin pixels in the third 
    %largest region is less than 30 % of the total skin count, the image is not nude.
%     end
    
    [Ir Ix] = find(amount_skin >= 35);
    Ix = sum(sum(Ix));
    if Ix >= 1
     disp('this frame is nude')  
     count_frame = count_frame+1;
    else
        disp('this frame not is nude')  
    end
    
    datatraining = [0
    10
    100
    150
    170
    300
    500
    700
    900
    1000
    2000
    4000
    6000
    8000
    10000
    20000
    40000
    50000
    70000
    90000
    95000
    100000
    200000
    250000
    400000
    600000
    750000
    900000
    1000000
    ];
%%
dataMatrix = amount_skin;
queryMatrix = datatraining;
kn = 1;

neighborIds = zeros(size(queryMatrix,1),kn);
neighborDistances = neighborIds;

numDataVectors = size(dataMatrix,1);
numQueryVectors = size(queryMatrix,1);

for i=1:numQueryVectors,
    dist = sum((repmat(queryMatrix(i,:),numDataVectors,1)-dataMatrix).^2,2);
    [sortval sortpos] = sort(dist,'ascend');
     neighborIds(i,:) = sortpos(1:kn);
    neighborDistances(i,:) = sqrt(sortval(1:kn));
end

[mini Ix] = min(neighborDistances);
if Ix >= 1 && Ix <= 16
    arry_o(:,k) = 0;
elseif Ix >= 17
    arry_o(:,k) = 1;
end

end
sumarry_o = sum(arry_o);
if sumarry_o >= 100
    disp('this video is nude')  
else
    disp('this video not is nude')
end

% end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Read video
global filename_v
global BWs
xyloObj = VideoReader(filename_v);
get(xyloObj)
nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

resX = vidHeight;
resY = vidWidth;

position = [23 373;35 185]; 
box_color = {'red','green'};
%%
count_frame = 0;
oldPoints = [];
mov(1:nFrames) = ...
    struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),'colormap',[]);
for k = 5000 : nFrames %k = 15200 : 16000
    mov(k).cdata = read(xyloObj,k);
    rgb_im = mov(k).cdata;
    
    img = rgb_im; %ayyildiz-20501-yesil-desenli-bikini-1991-11-B
    axes(handles.axes1)
    imshow(img)
    %figure,imshow(img)
    %%
    img_hsv = rgb2hsv(img);
    %figure,imshow(img_hsv), impixelinfo
    %% thresholds
    h = img_hsv(:,:,1);
    s = img_hsv(:,:,2);
    v = img_hsv(:,:,3);
    [rhsv chsv] = size(h);
    out_hsv = h;
    for ihsv = 1:rhsv
        for jhsv = 1:chsv
            if h(ihsv,jhsv) >= 0.01 && h(ihsv,jhsv) <= 0.05 && s(ihsv,jhsv) >= 0.68 && s(ihsv,jhsv) <= 0.88 && v(ihsv,jhsv) >= 0.15 && v(ihsv,jhsv) <= 0.40
    %         if y(iycbcr,jycbcr) >= ymin-5 && y(iycbcr,jycbcr) <= ymax+20 && cb(iycbcr,jycbcr) >= cbmin-25 && cb(iycbcr,jycbcr) <= cbmax && cr(iycbcr,jycbcr) >= crmin && cr(iycbcr,jycbcr) <= crmax+25
                out_hsv(ihsv,jhsv) = 255;
            else
                out_hsv(ihsv,jhsv) = 0;
            end
        end
    end
    BW = im2bw(out_hsv);
    
    axes(handles.axes2)
    imshow(BW)
    %figure,imshow(BW), impixelinfo
    BW = sum(sum(BW))
    
    BW_BW(k,:) = BW;
    
    if BW >= 0 && BW <= 1000
        ss(:,k) = 2;
        disp('this frame not is nude')
    end
    
    if BW >= 1001 && BW <= 10000
        ss(:,k) = 4;
        disp('this frame not is nude')
    end
    
    if BW >= 10001 && BW <= 100000
        ss(:,k) = 6;
        disp('this frame is nude')
    end
    
    if BW >= 100001 && BW <= 1000000
        ss(:,k) = 8;
        disp('this frame is nude')
    end

end
%%
check2 = find(ss == 2);
[rcheck2 ccheck2] = size(check2);
for icheck2 = 1:rcheck2
    for jcheck2 = 1:ccheck2
        if check2(icheck2,jcheck2) == 0
            o2(icheck2,jcheck2) = 0;
        else
            o2(icheck2,jcheck2) = 1;
        end
    end
end
o2 = sum(o2);
%%
check4 = find(ss == 4);
[rcheck4 ccheck4] = size(check4);
for icheck4 = 1:rcheck4
    for jcheck4 = 1:ccheck4
        if check4(icheck4,jcheck4) == 0
            o4(icheck4,jcheck4) = 0;
        else
            o4(icheck4,jcheck4) = 1;
        end
    end
end
o4 = sum(o4);
%%
check6 = find(ss == 6);
[rcheck6 ccheck6] = size(check6);
for icheck6 = 1:rcheck6
    for jcheck6 = 1:ccheck6
        if check6(icheck6,jcheck6) == 0
            o6(icheck6,jcheck6) = 0;
        else
            o6(icheck6,jcheck6) = 1;
        end
    end
end
o6 = sum(o6);
%%
check8 = find(ss == 8);
 [rcheck8 ccheck8] = size(check6);
for icheck8 = 1:rcheck8
    for jcheck8 = 1:ccheck8
        if check6(icheck8,jcheck8) == 0
            o8(icheck8,jcheck8) = 0;
        else
            o8(icheck8,jcheck8) = 1;
        end
    end
end
o8 = sum(o8);
tt = [o2,o4,o6,o8];
test_data = max(tt);
frame_test_data(:,k) = test_data;
%%
 datatraining = [2
     4
     6
     8
    ];
%%
dataMatrix = test_data;
queryMatrix = datatraining;
kn = 1;

neighborIds = zeros(size(queryMatrix,1),kn);
neighborDistances = neighborIds;

numDataVectors = size(dataMatrix,1);
numQueryVectors = size(queryMatrix,1);

for i=1:numQueryVectors,
    dist = sum((repmat(queryMatrix(i,:),numDataVectors,1)-dataMatrix).^2,2);
    [sortval sortpos] = sort(dist,'ascend');
     neighborIds(i,:) = sortpos(1:kn);
    neighborDistances(i,:) = sqrt(sortval(1:kn));
end

[mini Ix] = min(neighborDistances);
if Ix == 1 
    disp('this video not is nude');
    count
elseif Ix == 2 
    disp('this video not is nude');
    elseif Ix == 3
    disp('this video is nude');
    elseif Ix == 4 
    disp('this video is nude');
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Clean-up MATLAB's environment
 global filename_a
 global MFCCs_array
    % Define variables
    Tw = 25;                % analysis frame duration (ms)
    Ts = 10;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 20;                 % number of filterbank channels 
    C = 12;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 300;               % lower frequency limit (Hz)
    HF = 3700;              % upper frequency limit (Hz)
%%
    % Read speech samples, sampling rate and precision from file
    [ speech, fs ] = audioread( filename_a );

    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
                    mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

    MFCCs_vec = sum(sum(MFCCs))
    MFCCs_array = MFCCs_vec;
    
    %%
    datatraining = [0
    10
    100
    150
    170
    300
    500
    700
    900
    1000
    2000
    4000
    6000
    8000
    10000
    20000
    40000
    50000
    70000
    90000
    95000
    100000
    200000
    250000
    400000
    600000
    750000
    900000
    1000000
    ];
    %%
    dataMatrix = MFCCs_vec;
    queryMatrix = datatraining;
    kn = 1;

    neighborIds = zeros(size(queryMatrix,1),kn);
    neighborDistances = neighborIds;

    numDataVectors = size(dataMatrix,1);
    numQueryVectors = size(queryMatrix,1);

    for i=1:numQueryVectors,
        dist = sum((repmat(queryMatrix(i,:),numDataVectors,1)-dataMatrix).^2,2);
        [sortval sortpos] = sort(dist,'ascend');
         neighborIds(i,:) = sortpos(1:kn);
        neighborDistances(i,:) = sqrt(sortval(1:kn));
    end

    [mini Ix] = min(neighborDistances);
    Ix
    if Ix >= 1 && Ix <= 16
        disp('this video is blood')  
    elseif Ix >= 17
        disp('this video not is blood')
    end
    
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
