function X = helper(M)

% should pass square matrix pages
sn = size(M);
m=sn(1);
n=sn(2);
p=prod(sn(3:end));
M=reshape(M,[m,n,p]);
% Build sparse matrix and solve
I = reshape(1:m*p,m,1,p);
I = repmat(I,[1 n 1]); % m x n x p
J = reshape(1:n*p,1,n,p);
J = repmat(J,[m 1 1]); % m x n x p
M = sparse(I(:),J(:),M(:));
clear I J
RHS = repmat(eye(m),[p,1]);
X = M \ RHS;
clear RHS M
X = reshape(X, [n p m]);
X = permute(X,[1,3,2]);
X = reshape(X,[n,m,sn(3:end)]);
end % multinv