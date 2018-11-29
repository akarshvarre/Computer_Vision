% File Name: rmHorSeam.m
% Author:
% Date:

function [Iy, E] = rmHorSeam(I, My, Tby)
% Input:
%   I is the image. Note that I could be color or grayscale image.
%   My is the cumulative minimum energy map along horizontal direction.
%   Tby is the backtrack table along horizontal direction.

% Output:
%   Iy is the image removed one row.
%   E is the cost of seam removal

% Write Your Code Here

row = size(I,1);
col = size(I,2);

%Initialize Iy
Iy = zeros(row-1,col,3);

%return E
% [E,index4] = min(My(:,col));


%Loop through each col and find the pixel to be removed and remove it.
for k=1:3
    [E,index4] = min(My(:,col));
    for j=col:-1:1
        Val=I(:,j,k);
        
        Iy(:,j,k)=[Val(1:index4-1);Val(index4+1:end)];
        index4=index4+Tby(index4,j);
        
    end
end

Iy = uint8(Iy);





end