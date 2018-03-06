clc
close all
clear all
%%
count_frame = 0;

count_0to2 = 0;
count_2to4 = 0;
count_4to6 = 0;
count_6to8 = 0;
count_8up = 0;

for iii = 1:1000
    str = ['E:/', 'video_2_JPG/', 'A perfect gateway (12-1-2017 1-06-24 AM)/', num2str(iii), '.jpg'];
    rgb_im = imread(str); %ayyildiz-20501-yesil-desenli-bikini-1991-11-B
    
    img = rgb_im; %ayyildiz-20501-yesil-desenli-bikini-1991-11-B
  %  figure,imshow(img)
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
   % figure,imshow(BW), impixelinfo
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
        count_frame = count_frame+1;
    else
        disp('not found violent')
    end
    
    BW = sum(sum(BW));
    BW_BW(iii,:) = BW;
    
    if BW >= 0 && BW <= 1000
        ss(iii) = 0;
        count_0to2 = count_0to2+1;
    
    elseif BW >= 1001 && BW <= 10000
        ss(iii) = 2;
        count_2to4 = count_2to4+1;
    
    elseif BW >= 10001 && BW <= 100000
        ss(iii) = 4;
        count_4to6 = count_4to6+1;
    elseif BW >= 100001 && BW <= 1000000
        ss(iii) = 6;
         count_6to8 = count_6to8+1;
    else
         ss(iii) = 8;
        count_8up = count_8up+1;
    end
    
    
end
 count_0to2
 count_2to4
 count_4to6
 count_6to8
 count_8up