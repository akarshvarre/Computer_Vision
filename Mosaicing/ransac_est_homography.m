% File name: ransac_est_homography.m
% Author:
% Date created:

function [H, inlier_ind] = ransac_est_homography(x1, y1, x2, y2, thresh)
% Input:
%    y1, x1, y2, x2 are the corresponding point coordinate vectors Nx1 such
%    that (y1i, x1i) matches (x2i, y2i) after a preliminary matching
%    thresh is the threshold on distance used to determine if transformed
%    points agree

% Output:
%    H is the 3x3 matrix computed in the final step of RANSAC
%    inlier_ind is the nx1 vector with indices of points in the arrays x1, y1,
%    x2, y2 that were found to be inliers

% Write Your Code Here
nRANSAC = 200;
npoints = length(x1);

% copy_x1 = x1;
% copy_x2 = x2;
% copy_y1 = y1;
% copy_y2 = y2;

tempH={};
count=zeros(nRANSAC,1);
indices = {};

for i=1:nRANSAC
    indi = randperm(npoints,4);
    X = x1(indi);
    Y = y1(indi);
    x = x2(indi);
    y = y2(indi);
%     copy_x1(indi) = inf;
%     copy_x2(indi) = inf;
%     copy_y1(indi) = inf;
%     copy_y2(indi) = inf;
    tempH{i} = est_homography(X,Y,x,y);
    [new_x, new_y] = apply_homography(tempH{i}, x2, y2);
%     Hpoints = [copy_y1,copy_x1,ones(npoints,1)]*tempH{i}';
%     new_y = Hpoints(:,1)./Hpoints(:,3);
%     new_x = Hpoints(:,2)./Hpoints(:,3);
    
    distance = vecnorm(([y1,x1]-[new_y,new_x]),2,2);
    if isempty(find(distance<thresh))
        indices{i} = zeros(1,1);
    else
        indices{i} = find(distance<thresh);
    end
    count(i) = length(indices{i});
    
%     copy_x1 = x1;
%     copy_x2 = x2;
%     copy_y1 = y1;
%     copy_y2 = y2;
end

[~,max_ind] = max(count);

inliers = indices{max_ind};

temp_indices = zeros(npoints,1);
temp_indices(inliers) = 1;

inlier_ind = temp_indices;
H = est_homography(x1(inliers),y1(inliers),x2(inliers),y2(inliers));
end

