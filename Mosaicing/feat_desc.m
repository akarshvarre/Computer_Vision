% File name: feat_desc.m
% Author:
% Date created:

function [descs] = feat_desc(img, x, y)
% Input:
%    img = double (height)x(width) array (grayscale image) with values in the
%    range 0-255
%    x = nx1 vector representing the column coordinates of corners
%    y = nx1 vector representing the row coordinates of corners

% Output:
%   descs = 64xn matrix of double values with column i being the 64 dimensional
%   descriptor computed at location (xi, yi) in im

% Write Your Code Here

%image padding
img = im2double(padarray(img, [20, 20]));


n = length(y);
descs = zeros(64,n);

%looping through all the corners points
for i=1:n
    window40 = img(y(i):y(i)+39, x(i):x(i)+39);
    window40 = imgaussfilt(window40,5);
    window8 =window40(1:5:40,1:5:40);
    oneD_window =reshape(window8,[64,1]);
    oneD_window = oneD_window-mean(oneD_window);
    oneD_window = oneD_window./std(oneD_window,1);
    descs(:,i) = oneD_window;
end