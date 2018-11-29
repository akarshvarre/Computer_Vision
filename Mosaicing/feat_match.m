% File name: feat_match.m
% Author:
% Date created:

function [match] = feat_match(descs1, descs2)
% Input:
%   descs1 is a 64x(n1) matrix of double values
%   descs2 is a 64x(n2) matrix of double values

% Output:
%   match is n1x1 vector of integers where m(i) points to the index of the
%   descriptor in p2 that matches with the descriptor p1(:,i).
%   If no match is found, m(i) = -1


n = size(descs1,2);

%Intilialize match
match = -ones(n,1);

%Loop through all the 8x8 windows
for i=1:n
    temp = repmat(descs1(:,i),1,n);
    norm_mat(i,:) = vecnorm(temp-descs2,2);
    [sorted_norm_mat, indexes] = sort(norm_mat(i,:), 2, 'ascend');
    
    ratio = sorted_norm_mat(1)/sorted_norm_mat(2);
    if(ratio<0.6)
        match(i) = indexes(1);
    end
end
end