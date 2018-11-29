% File Name: cumMinEngVer.m
% Author:
% Date:

function [Mx, Tbx] = cumMinEngVer(e)
% Input:
%   e is the energy map

% Output:
%   Mx is the cumulative minimum energy map along vertical direction.
%   Tbx is the backtrack table along vertical direction.

% Write Your Code Here




%everything is same as cumMinHor.m except that I took the transpose of e
%matrix and performed a cumMinHor and finally I took the transpose again to
%genrate cumMinVer
row = size(e',1);
col = size(e',2);

a=e';
b = reshape(a,row*col,1);
b1= [inf(size(a,1),1);b(1:end-row)];

b2=[inf(size(a,1),1);b(2:end-row+1)];
b2(2*row:row:end) = inf;

b3=[inf(size(a,1)+1,1);b(1:end-row-1)];
b3(2*row+1:row:end) = inf;

find_min = [b3,b1,b2];

find_min(1:row,:) = 0;

[val,index1] = min(find_min,[],2);

temp_Mx = b+val;

temp_Tbx = index1-2;

Mx = reshape(temp_Mx,size(e'));

Tbx = reshape(temp_Tbx,size(e'));

Mx = Mx';
Tbx = Tbx';


end