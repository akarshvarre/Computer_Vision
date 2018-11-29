% File name: anms.m
% Author:
% Date created:

function [y, x, rmax] = anms(cimg, max_pts)
% Input:
% cimg = corner strength map
% max_pts = number of corners desired

%Find the corners
corner_peaks = imregionalmax(cimg);
corner_idx = find(corner_peaks == true);
[y, x] = ind2sub(size(cimg), corner_idx);


%Correspoiding corner strengths
strength = cimg(corner_idx);
copy_strength = strength;

corners = [y,x,strength];

%Corner Points
points = [y,x];
copy_points = points;

n = size(corners,1);
rmax = zeros(n,1);

%Loop through all the corners
for i=1:n
    copy_points(i,:) = inf;
    
    %Distance b/n ith corner and all the corners
    distance = vecnorm(repmat(points(i,:),n,1)-copy_points,2,2);
    
    %Strength comparison
    valid_strength = repmat(0.9*strength(i,:),n,1)-copy_strength;
    indexes = find(valid_strength<0);
    
    %Valid distances
    valid_distances = distance(indexes);
    
    %Get rmax
    [min_distance] = min(valid_distances);
    rmax(i) =  min_distance;
    copy_points = points;

end

%sort rmax 
[sorted_rmax,sort_indices] = sort(rmax,'descend');

%Sort corners according to sorted_rmax 
y = y(sort_indices);
x=x(sort_indices);
max_pts = min([length(x),max_pts]);

%Select only max_pts number of good corners
y = y(1:max_pts);
x = x(1:max_pts);
rmax = sorted_rmax(1:max_pts);

end