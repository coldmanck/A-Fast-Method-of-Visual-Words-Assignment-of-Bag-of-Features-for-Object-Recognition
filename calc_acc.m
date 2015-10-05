function [P, LQ, t_id, rec] = calc_acc(ID, QD, CL, QL)

% tic
% l = length(QD);
% LQ = zeros(l, 10);
% for i = 1:l,
%     LQ(i, :) = CL(ID(i), :);
% end;
% toc

tic
l = length(QD);
LQ = zeros(l, 1);
for i = 1:l,
    LQ(i) = CL(ID(i), 1);   % LQ: id of the nearset patch found by FLANN
end;
t_id = toc;

% if id found by FLANN (LQ(i)) == any one of top 10 of recent id of SIFT
P = zeros(1, 10); % P(N) = percent of Top N
for i = 1:l,
    for j = 1:10
        if LQ(i) == QL(i, j), % QL: top 10 of id of nearest patch from original index (table)
            P(j) = P(j) + 1; 
        end;
    end;
end;

p = 0;
rec = zeros(10,1);
for i = 1:10,
    p = p + P(i)/l;
    fprintf('%.03f\n', p);
    rec(i) = p;
end;
