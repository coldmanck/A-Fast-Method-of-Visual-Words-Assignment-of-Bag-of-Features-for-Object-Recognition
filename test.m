% A = rand(4,1);
% C = rand(3,1);
% B = zeros(10,1);
% 
% m = 1;
% n = length(A);
% 
% B(m:(m+n-1), 1) = A;
% m = m+n;
% n = length(C);
% B(m:(m+n-1), 1) = C

A = rand(10,4);
B = rand(5,4);

D = pdist2(A,B)
[Ds, I]= pdist2(A,B,'euclidean', 'Smallest',1)