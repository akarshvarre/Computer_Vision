function [im1_pts, im2_pts] = click_correspondences(im1, im2)
%CLICK_CORRESPONDENCES Find and return point correspondences between images
%   Input im1: source image
%	Input im2: target image
%	Output im1_pts: correspondence-coordinates in the source image
%	Output im2_pts: correspondence-coordinates in the target image

%% Your code goes here
% You can use built-in functions such as cpselect to manually select the
% correspondences
%cpstruct_in = {};

[im1_pts,im2_pts] = cpselect(im1,im2,'Wait',true);
variables = [1,1;size(im1,1),1;1,size(im1,1);size(im1,1),size(im1,1)];
im1_pts = [im1_pts;variables];
im2_pts = [im2_pts;variables];
save im1_pts;

save im2_pts;


end
