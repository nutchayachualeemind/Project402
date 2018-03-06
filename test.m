clc
close all
clear all
%%
img = imread('137057257214.jpg');
img = rgb2gray(img);
figure, imshow(img), impixelinfo

[r c] = size(img)
for i = 1:r
    for j = 1:c
        if img(i,j) >= 20 && img(i,j) <= 50
            out(i,j) = 255;
        else
            out(i,j) = 0;
        end
    end
end
figure, imshow(out)