% File Name: rmVerSeam.m
% Author:
% Date:

function [Ix, E] = rmVerSeam(I, Mx, Tbx)
% Input:
%   I is the image. Note that I could be color or grayscale image.
%   Mx is the cumulative minimum energy map along vertical direction.
%   Tbx is the backtrack table along vertical direction.

% Output:
%   Ix is the image removed one column.
%   E is the cost of seam removal

% Write Your Code Here
row = size(I,1);
col = size(I,2);

%Initialize Ix
Ix = zeros(row,col-1,3);

%return E
% [E,index3] = min(Mx(row,:));


%Loop through each row and find the pixel to be removed and remove it.
for k=1:3
    [E,index3] = min(Mx(row,:));
    for j=row:-1:1
        Val=I(j,:,k);
        
        
        Ix(j,:,k)=[Val(1:index3-1),Val(index3+1:end)];
        index3=index3+Tbx(j,index3);
        
    end
end

Ix = uint8(Ix);
end