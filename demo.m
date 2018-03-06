clc
close all
clear all
%%
reqToolboxes = {'Computer Vision System Toolbox', 'Image Processing Toolbox'};
if( ~checkToolboxes(reqToolboxes) )
 error('detectFaceParts requires: Computer Vision System Toolbox and Image Processing Toolbox. Please install these toolboxes.');
end

img = imread('91564-r-1431691875970.jpg'); %ayyildiz-20501-yesil-desenli-bikini-1991-11-B

detector = buildDetector(); % Create Haar like feature
[bbox bbimg faces bbfaces] = detectFaceParts(detector,img,2);
s_out_ycbcr_add = 0;

for i=1:size(bbfaces,1) % size(bbfaces,1) = amount of face
face = faces{i,1};
figure;imshow(face);
%% finding average RGB for threshold
rmin = round(min(mean(face(:,:,1))));
rmax = round(max(mean(face(:,:,1))));

gmin = round(min(mean(face(:,:,2))));
gmax = round(max(mean(face(:,:,2))));

bmin = round(min(mean(face(:,:,3))));
bmax = round(max(mean(face(:,:,3))));
%%
rgb_im = img;
figure, imshow(rgb_im), title('RGB'), impixelinfo
r = rgb_im(:,:,1);
g = rgb_im(:,:,2);
b = rgb_im(:,:,3);
out_rgb = r;
[rrgb crgb] = size(r);
%% Threshold
for irgb = 1:rrgb
    for jrgb = 1:crgb
%         if r(irgb,jrgb) >= 50 && r(irgb,jrgb) <= 180 && g(irgb,jrgb) >= 15 && g(irgb,jrgb) <= 140 && b(irgb,jrgb) >= 20 && b(irgb,jrgb) <= 120
        if r(irgb,jrgb) >= rmin-30 && r(irgb,jrgb) <= rmax+50 && g(irgb,jrgb) >= gmin-50 && g(irgb,jrgb) <= gmax+50 && b(irgb,jrgb) >= bmin-25 && b(irgb,jrgb) <= bmax+40
         
            out_rgb(irgb,jrgb) = 255;
        else
            out_rgb(irgb,jrgb) = 0;
        end
    end
end
% out_rgb = imfill(out_rgb, 'holes');
 figure, imshow(out_rgb), title('out_rgb'), impixelinfo           
%% hsv
hsv_im = rgb2hsv(rgb_im);
%% finding average HSV for threshold
hmin = min(mean(hsv_im(:,:,1)));
hmax = max(mean(hsv_im(:,:,1)));
smin = min(mean(hsv_im(:,:,2)));
smax = max(mean(hsv_im(:,:,2)));
vmin = min(mean(hsv_im(:,:,3)));
vmax = max(mean(hsv_im(:,:,3)));
%%
figure, imshow(hsv_im), title('hsv'), impixelinfo
h = hsv_im(:,:,1);
s = hsv_im(:,:,2);
v = hsv_im(:,:,3);
[rhsv chsv] = size(h);
out_hsv = h;
for ihsv = 1:rhsv
    for jhsv = 1:chsv
%         if h(ihsv,jhsv) >= 0.02 && h(ihsv,jhsv) <= 0.08 && s(ihsv,jhsv) >= 0.4 && s(ihsv,jhsv) <= 0.7 && v(ihsv,jhsv) >= 0.1 && v(ihsv,jhsv) <= 0.8
        if h(ihsv,jhsv) >= hmin-0.04 && h(ihsv,jhsv) <= hmax && s(ihsv,jhsv) >= smin && s(ihsv,jhsv) <= smax+0.2 && v(ihsv,jhsv) >= vmin-0.07 && v(ihsv,jhsv) <= vmax+0.3    
            out_hsv(ihsv,jhsv) = 255;
        else
            out_hsv(ihsv,jhsv) = 0;
        end
    end
end
% out_hsv = imfill(out_hsv, 'holes');
 figure, imshow(out_hsv), title('out_hsv'), impixelinfo           
%% ycbcr
ycbcr_im = rgb2ycbcr(rgb_im);
figure, imshow(ycbcr_im)
%% finding average ycbcr for threshold
ymin = min(mean(ycbcr_im(:,:,1)));
ymax = max(mean(ycbcr_im(:,:,1)));
cbmin = min(mean(ycbcr_im(:,:,2)));
cbmax = max(mean(ycbcr_im(:,:,2)));
crmin = min(mean(ycbcr_im(:,:,3)));
crmax = max(mean(ycbcr_im(:,:,3)));
%%
figure, imshow(ycbcr_im), title('ycbcr'), impixelinfo
y = ycbcr_im(:,:,1);
cb = ycbcr_im(:,:,2);
cr = ycbcr_im(:,:,3);
[rycbcr cycbcr] = size(y);
out_ycbcr = y;
for iycbcr = 1:rycbcr
    for jycbcr = 1:cycbcr
        if y(iycbcr,jycbcr) >= 50 && y(iycbcr,jycbcr) <= 150 && cb(iycbcr,jycbcr) >= 100 && cb(iycbcr,jycbcr) <= 118 && cr(iycbcr,jycbcr) >= 130 && cr(iycbcr,jycbcr) <= 160
%         if y(iycbcr,jycbcr) >= ymin-5 && y(iycbcr,jycbcr) <= ymax+20 && cb(iycbcr,jycbcr) >= cbmin-25 && cb(iycbcr,jycbcr) <= cbmax && cr(iycbcr,jycbcr) >= crmin && cr(iycbcr,jycbcr) <= crmax+25
            out_ycbcr(iycbcr,jycbcr) = 255;
        else
            out_ycbcr(iycbcr,jycbcr) = 0;
        end
    end
end
% out_ycbcr = imfill(out_ycbcr, 'holes');
out_ycbcr = bwareaopen(out_ycbcr, 5000);
 figure, imshow(out_ycbcr), title('out_ycbcr'), impixelinfo  
 
%% YIQ
xn=rgb2ntsc(rgb_im);
%%
Ymin = min(mean(xn(:,:,1)));
Ymax = max(mean(xn(:,:,1)));
Imin = min(mean(xn(:,:,2)));
Imax = max(mean(xn(:,:,2)));
Qmin = min(mean(xn(:,:,3)));
Qmax = max(mean(xn(:,:,3)));
%%
figure, imshow(xn), title('YIQ'), impixelinfo
Y = xn(:,:,1);
I = xn(:,:,2);
Q = xn(:,:,3);
[rYIQ cYIQ] = size(Y);
out_YIQ = Y;
for iYIQ = 1:rYIQ
    for jYIQ = 1:cYIQ
%         if Y(iYIQ,jYIQ) >= 0.15 && Y(iYIQ,jYIQ) <= 0.5 && I(iYIQ,jYIQ) >= 0.10 && I(iYIQ,jYIQ) <= 0.15 && Q(iYIQ,jYIQ) >= 0 && Q(iYIQ,jYIQ) <= 0.03
        if Y(iYIQ,jYIQ) >=Ymin-0.05 && Y(iYIQ,jYIQ) <=Ymax+0.05 && I(iYIQ,jYIQ) >= Imin-0.01 && I(iYIQ,jYIQ) <= Imax+0.01 && Q(iYIQ,jYIQ) >= Qmin && Q(iYIQ,jYIQ) <= Qmax
            out_YIQ(iYIQ,jYIQ) = 255;
        else
            out_YIQ(iYIQ,jYIQ) = 0;
        end
    end
end
% out_YIQ = imfill(out_YIQ, 'holes');
 figure, imshow(out_YIQ), title('out_YIQ'), impixelinfo     
% Please uncoment to run demonstration of detectRotFaceParts
%{
 img = imrotate(img,180);
 detector = buildDetector(2,2);
 [fp bbimg faces bbfaces] = detectRotFaceParts(detector,img,2,15);

 figure;imshow(bbimg);
 for i=1:size(bbfaces,1)
  figure;imshow(bbfaces{i});
 end
%}
%% RATE
s_out_ycbcr = sum(sum(im2bw(out_ycbcr)));
s_out_ycbcr_add = s_out_ycbcr+s_out_ycbcr_add;
end

if s_out_ycbcr_add >= 0 && s_out_ycbcr_add <= 100000
    disp('13+')
elseif s_out_ycbcr_add >= 100001 && s_out_ycbcr_add <= 500000
    disp('15+')
    elseif s_out_ycbcr_add >= 500001
    disp('18+')
end
