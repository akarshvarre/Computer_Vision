% File Name: cumMinEngHor.m
% Author:
% Date:

function [My, Tby] = cumMinEngHor(e)
% Input:
%   e is the energy map.

% Output:
%   My is the cumulative minimum energy map along horizontal direction.
%   Tby is the backtrack table along horizontal direction.

% Write Your Code Here

row1 = size(e,1);
col1 = size(e,2);

% Make a copy of e(not necessay)
a1=e;

%e reshaped into a 1D array
b = reshape(a1,row1*col1,1);

%all the corresponding centered energies
b1= [inf(size(a1,1),1);b(1:end-row1)];

%all the corresponding bottom energies
b2=[inf(size(a1,1),1);b(2:end-row1+1)];
b2(2*row1:row1:end) = inf;

%all the corresponding top energies
b3=[inf(size(a1,1)+1,1);b(1:end-row1-1)];
b3(2*row1+1:row1:end) = inf;

%concatenate and find the min
find_min = [b3,b1,b2];
find_min(1:row1,:) = 0;
[val,index] = min(find_min,[],2);

%compute the value matrix. This is now a 1D matrix
value_My = b+val;

%1D path matrix
temp_Tby = index-2;

%value and path matrix reshaped
My = reshape(value_My,size(e));

Tby = reshape(temp_Tby,size(e));



end