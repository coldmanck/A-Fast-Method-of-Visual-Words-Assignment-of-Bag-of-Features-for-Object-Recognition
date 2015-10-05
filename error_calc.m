function [D1, D2 ,D3] = error_calc(LQ, SQ, QL, B)

SQ = SQ';

l = length(LQ);
D1 = zeros(1, l);
D2 = zeros(1, l);
D3 = zeros(1, l);

tic
for i = 1:l,
    P = SQ(:, i);
    Q = B(:, LQ(i));
    R = B(:, QL(i, 1));
    d = norm(Q - P);
    D1(i) = d;
    d = norm(R - P);
    D2(i) = d;
    d = norm(R - Q);
    D3(i) = d;
end;
toc 