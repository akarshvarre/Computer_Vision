 function [offsetY,offsetX] = getoffset(Target_Image)


% img = imread('TargetImage.png');
% img = rgb2gray(img);
figure;
imshow(Target_Image);
[x,y] = getpts;
offsetY = x;
offsetX = y;
 end