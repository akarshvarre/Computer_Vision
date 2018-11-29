% File name: apply_homography.m
% Author:
% Date created:

function [X, Y] = apply_homography(H, x, y)
% Input:
%   H : 3*3 homography matrix, refer to setup_homography
%   x : the column coords vector, n*1, in the source image
%   y : the column coords vector, n*1, in the source image

% Output:
%   X : the column coords vector, n*1, in the destination image
%   Y : the column coords vector, n*1, in the destination image

% Write Your Code Here

p1 = [x'; y'; ones(1, length(x))];
q1 = H*p1;
q1 = q1./[q1(3, :); q1(3,:); q1(3, :)];

X = q1(1,:)';
Y = q1(2, :)';

end