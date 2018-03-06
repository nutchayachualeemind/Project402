clc
close all
clear all
%%
img = imread('maxresdefault.jpg'); %ayyildiz-20501-yesil-desenli-bikini-1991-11-B
%% ycbcr
ycbcr_im = rgb2ycbcr(img);
figure, imshow(ycbcr_im)
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
figure, imshow(out_ycbcr)
total_skin = sum(sum(out_ycbcr));
% out_ycbcr = imfill(out_ycbcr, 'holes');
%%
% 2.	คำนาณคำนวณเปอร์เซ็นต์ของพิกเซลผิวเทียบกับขนาดของภาพ (skin percentage)
% 3.	ระบุพิกเซลผิวที่เชื่อมต่อกันเพื่อสร้างบริเวณผิวและคำนวณจำนวนพื้นที่ผิว
% 4.	ระบุพิกเซลที่เป็นของผิวที่ใหญ่ที่สุดสามregions 

BW2 = bwareafilt(out_ycbcr,3);
figure, imshow(BW2), title('bwareafilt'), impixelinfo  
%% 5.	ระบุด้านซ้ายสุด บนสุด(upper) ด้านขวาสุดและพิกเซลผิวด้านล่างสุดของสามผิวที่ใหญ่ที่สุดสร้างรูปหลายเหลี่ยมขึ้นมา
labeledImage = bwlabel( BW2);
measurements = regionprops(labeledImage, 'BoundingBox', 'Area');
for k = 1 : length(measurements)
  thisBB = round(measurements(k).BoundingBox);
  thisBB = thisBB-2;
  thisBB1(k,:) = thisBB;
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','r','LineWidth',2 )
%%
% 6.	คำนวณพื้นที่และคำนวณพิกเซลผิวในรูปหลายเหลี่ยมเพื่อหา skin percentage  ของแต่ละจุด
% 7.	ถ้าเปอร์เซ็นต์ของผิวพิกเซลสัมพันธ์กับขนาดภาพ <  15 % = not nude

cut = out_ycbcr(thisBB(2):thisBB(4)+thisBB(2),thisBB(1):thisBB(3)); % ตัดแต่ละส่วน
figure, imshow(cut),title('cut')

amount_skin = sum(sum(cut));
precent_skin = (amount_skin/total_skin) * 100;
precent_skin_array(k,:) = precent_skin;
%%
% 8.	ถ้าจำนวน number of skin pixels in the largest skin region is less than 35% 
%of the total skin count, the number of skin pixels in the second largest region 
%is less than 30% of the total skin count and the number of skin pixels in the third 
%largest region is less than 30 % of the total skin count, the image is not nude.
end
[Ir Ix] = find(precent_skin_array >= 35);
Ix = sum(sum(Ix));
if Ix >= 1
 disp('nude')  
else
    disp('not nude')  
end

% if s_out_ycbcr_add >= 0 && s_out_ycbcr_add <= 100000
%     disp('13+')
% elseif s_out_ycbcr_add >= 100001 && s_out_ycbcr_add <= 500000
%     disp('15+')
%     elseif s_out_ycbcr_add >= 500001
%     disp('18+')
% end
