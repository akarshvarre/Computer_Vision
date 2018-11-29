% File name: mymosaic.m
% Author:
% Date created:

function [final_img] = mymosaic(img_input)
% Input:
%   img_input is a cell array of color images (HxWx3 uint8 values in the
%   range [0,255])
%
% Output:
% img_mosaic is the output mosaic

left = img_input{2};
middle = img_input{1};

%Gray scale
leftG = rgb2gray(left);
middleG = rgb2gray(middle);



%Corner metric matrix
cimgL = corner_detector(leftG);
cimgM = corner_detector(middleG);


%ANMS
max_pts = 500;
[yL, xL, rmaxL] = anms(cimgL, max_pts);
[yM, xM, rmaxM] = anms(cimgM, max_pts);



%find the descriptors
descsL = feat_desc(leftG, xL, yL);
descsM = feat_desc(middleG, xM, yM);

%Find the match
matchLM = feat_match(descsL, descsM);

%Corresponding matched corners
xL_LM = xL((matchLM>0));
yL_LM = yL((matchLM>0));
xM_LM = xM(matchLM(matchLM>0));
yM_LM = yM(matchLM(matchLM>0));

figure;
subplot(1,2,1);
imshow('1L.jpg');
hold on;
scatter(xL_LM,yL_LM,'r');

subplot(1,2,2);
imshow('1M.jpg');
hold on;
scatter(xM_LM,yM_LM,'b');

%threshold for ransac
thresh = 7;

[H_LM, inlier_ind_LM] = ransac_est_homography(xL_LM, yL_LM, xM_LM, yM_LM, thresh);
xL_LM_RANSAC = xL_LM(find(inlier_ind_LM));
yL_LM_RANSAC = yL_LM(find(inlier_ind_LM));
xM_LM_RANSAC = xM_LM(find(inlier_ind_LM));
yM_LM_RANSAC = yM_LM(find(inlier_ind_LM));


boundx_LM = [1;size(middle,2);1;size(middle,2)];
boundy_LM = [1;1;size(middle,1);size(middle,1)];



[trans_boundx_LM,trans_boundy_LM] = apply_homography(H_LM,boundx_LM,boundy_LM);

[transx_L,transy_L ] = meshgrid(round(min(trans_boundx_LM)):round(max(trans_boundx_LM)),round(min(trans_boundy_LM)):round(max(trans_boundy_LM)));

transx_L = reshape(transx_L, [numel(transx_L), 1]);
transy_L = reshape(transy_L, [numel(transy_L), 1]);


[trans2sourcex_L, trans2sourcey_L] = apply_homography(inv(H_LM), transx_L, transy_L);

index_LM = find(trans2sourcex_L >= 1 & trans2sourcex_L <= size(middle,2) & trans2sourcey_L >= 1 & trans2sourcey_L <= size(middle,1));


 transx_L = transx_L(index_LM);
 transy_L = transy_L(index_LM);

 trans2sourcex_L = trans2sourcex_L(index_LM);
 trans2sourcey_L = trans2sourcey_L(index_LM);


[X,Y] = meshgrid(1:size(middle,2),1:size(middle,1));
X = double(X);
Y = double(Y);

max_x = round(max([trans_boundx_LM; size(left, 2)]));
min_x = round(min([trans_boundx_LM;1]));

max_y = round(max([trans_boundy_LM;size(left,1)]));
min_y = round(min([trans_boundy_LM;1]));

final_col = (abs(max_x-min_x));
final_row = (abs(max_y-min_y));

final_img = zeros(final_row,final_col,3);

final_img((2-(min_y)):1+size(left,1)-(min_y), (2-(min_x)):1+size(left,2)-(min_x),:) = left;


linearInd = sub2ind(size(final_img), transy_L-(min_y)+1, transx_L-(min_x)+1,ones(size(transx_L)));
final_img(linearInd) = interp2(X,Y,double(middle(:, :, 1)),trans2sourcex_L,trans2sourcey_L);
linearInd = sub2ind(size(final_img), transy_L-(min_y)+1, transx_L-(min_x)+1,2.*ones(size(transx_L)));
final_img(linearInd) = interp2(X,Y,double(middle(:, :, 2)),trans2sourcex_L,trans2sourcey_L);
linearInd = sub2ind(size(final_img), transy_L-(min_y)+1, transx_L-(min_x)+1,3.*ones(size(transx_L)));
final_img(linearInd) = interp2(X,Y,double(middle(:, :, 3)),trans2sourcex_L,trans2sourcey_L);


figure;
imshow(uint8(final_img));
















end