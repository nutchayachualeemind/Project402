clc
close all
clear all
%%
img = imread('109779478.jpg'); %ayyildiz-20501-yesil-desenli-bikini-1991-11-B
figure,imshow(img)
%%
img_hsv = rgb2hsv(img);
figure,imshow(img_hsv), impixelinfo
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
figure,imshow(BW), impixelinfo
%%
% Label the binary image.
labeledImage = bwlabel(BW);
% Measure the solidity of all the blobs.
measurements = regionprops(labeledImage, 'Solidity');
% Sort in oder of decreasing solidity.
[sortedS, sortIndexes] = sort([measurements.Solidity], 'descend');
% Get the solidity of the most solid blob
highestSolidity = sortedS(1);
% Get the label of the most solid blob
labelWithHighestSolidity = sortIndexes(1);
if highestSolidity == 1
    disp('found violent')
else
    disp('not found violent')
end
