clc
close all
clear all
%%
count_frame = 0;

for iii = 1:1000
    str = ['E:/', 'video_2_JPG/', 'A perfect gateway (12-1-2017 1-06-24 AM)/', num2str(iii), '.jpg'];
    img = imread(str); %ayyildiz-20501-yesil-desenli-bikini-1991-11-B
    %% ycbcr
    ycbcr_im = rgb2ycbcr(img);
    figure, imshow(ycbcr_im)
    %% thresholds 1.	��˹�����ռ�������¡�ԡ�ŷ�����ռ���͡�ҡ�ԡ�ŷ��������ռ��
    y = ycbcr_im(:,:,1);
    ymin = min(min(y));
    ymax= max(max(y));
    cb = ycbcr_im(:,:,2);
    cbmin = min(min(cb));
    cbmax= max(max(cb));
    cr = ycbcr_im(:,:,3);
    crmin = min(min(cr));
    crmax= max(max(cr));
    [rycbcr cycbcr] = size(y);
    out_ycbcr = y;
    for iycbcr = 1:rycbcr
        for jycbcr = 1:cycbcr
%             if y(iycbcr,jycbcr) >= 80 && cb(iycbcr,jycbcr) >= 77 && cb(iycbcr,jycbcr) <= 135 && cr(iycbcr,jycbcr) >= 133 && cr(iycbcr,jycbcr) <= 173
            if y(iycbcr,jycbcr) >= ymin-5 && y(iycbcr,jycbcr) <= ymax+20 && cb(iycbcr,jycbcr) >= cbmin-25 && cb(iycbcr,jycbcr) <= cbmax && cr(iycbcr,jycbcr) >= crmin && cr(iycbcr,jycbcr) <= crmax+25
                out_ycbcr(iycbcr,jycbcr) = 255;
            else
                out_ycbcr(iycbcr,jycbcr) = 0;
            end
        end
    end
    out_ycbcr = im2bw(out_ycbcr);
    total_skin = sum(sum(out_ycbcr));
    % out_ycbcr = imfill(out_ycbcr, 'holes');
    %%
    % 2.	�ӹҳ�ӹǳ�����繵�ͧ�ԡ�ż����º�Ѻ��Ҵ�ͧ�Ҿ (skin percentage)
    % 3.	�кؾԡ�ż�Ƿ���������͡ѹ�������ҧ����ǳ�����Фӹǳ�ӹǹ��鹷����
    % 4.	�кؾԡ�ŷ���繢ͧ��Ƿ���˭����ش���regions 

    BW2 = bwareafilt(out_ycbcr,3);
    figure, imshow(BW2), title('out_ycbcr'), impixelinfo  
    %% 5.	�кش�ҹ�����ش ���ش(upper) ��ҹ����ش��оԡ�ż�Ǵ�ҹ��ҧ�ش�ͧ�����Ƿ���˭����ش���ҧ�ٻ����������������
    labeledImage = bwlabel( BW2);
    measurements = regionprops(labeledImage, 'BoundingBox', 'Area');
    for k = 1 : length(measurements)
      thisBB = abs(round(measurements(k).BoundingBox));
      thisBB = thisBB;
      thisBB1(k,:) = thisBB;
      rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
      'EdgeColor','r','LineWidth',2 )
    %%
    % 6.	�ӹǳ��鹷����Фӹǳ�ԡ�ż����ٻ����������������� skin percentage  �ͧ���Шش
    % 7.	��������繵�ͧ��Ǿԡ������ѹ��Ѻ��Ҵ�Ҿ <  15 % = not nude

    cut = out_ycbcr(thisBB(2):thisBB(4),thisBB(1):thisBB(3)); % �Ѵ������ǹ
    figure, imshow(cut)

    amount_skin = sum(sum(cut));
    precent_skin = (amount_skin/total_skin) * 100;
    precent_skin_array(k,:) = precent_skin;
    %%
    % 8.	��Ҩӹǹ number of skin pixels in the largest skin region is less than 35% 
    %of the total skin count, the number of skin pixels in the second largest region 
    %is less than 30% of the total skin count and the number of skin pixels in the third 
    %largest region is less than 30 % of the total skin count, the image is not nude.
    end
    [Ir Ix] = find(precent_skin_array >= 35);
    Ix = sum(sum(Ix));
    if Ix >= 1
     disp('nude')  
     count_frame = count_frame + 1;
    else
        disp('not nude')  
    end
    
   pp(:,iii) = precent_skin;
end
% if s_out_ycbcr_add >= 0 && s_out_ycbcr_add <= 100000
%     disp('13+')
% elseif s_out_ycbcr_add >= 100001 && s_out_ycbcr_add <= 500000
%     disp('15+')
%     elseif s_out_ycbcr_add >= 500001
%     disp('18+')
% end
