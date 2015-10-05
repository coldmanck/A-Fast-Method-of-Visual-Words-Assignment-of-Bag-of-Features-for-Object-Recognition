clear all;
clc;

%% set path
addpath('large_scale_svm');
addpath('sift');
addpath(genpath('sltoolbox'));
addpath(genpath('flann-1.8.4-src'));
addpath(genpath('pqcodes_matlab'));
addpath(genpath('yael'));
addpath(genpath('sparse_coding'));

%% parameter setting

% directory setup
data_dir = 'data';                  % directory to save the sift features of the chosen dataset
dataSet = 'Caltech101';
index_dir = ['index/', dataSet];

patch_size = 16;
n_of_extract = 5;

k = 1;                % number of elements to be returned
nsq = 8;              % number of subquantizers to be used (m in the paper)

coarsek = 256;        % number of centroids for the coarse quantizer
w = 8;                % number of cell visited per query


% define index and search parameters


%%
% index_p = retr_database_dir(rt_index_dir);

%%%%%%%%%% IMPORTANT IF ERROR CALC USED %%%%%%%%
%{
% dict_path = 'Results\reg_sc_b1024_20150109T130715.mat';
dict_path = 'Results\reg_sc_b1024_20090927T235404.mat';
load(dict_path);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for ann search
% CD = double(CD);
% CL = double(CL);
fprintf('making database and query\n');
[CD, CL, QD, QL, SQ, Learn] = cross_validation_pq(index_dir, data_dir, dataSet, n_of_extract);

%% BEFORE REGULARIZATION
CD2 = single(CD);
QD2 = single(QD);
Learn2 = single(Learn);

M = mean(CD2, 2);
for i = 1:256
    CD2(:, i) = CD2(:, i) - M;
end;

N = mean(QD2, 2);
for i = 1:256
    QD2(:, i) = QD2(:, i) - N;
end;

L = mean(Learn2, 2);
for i = 1:256
    Learn2(:, i) = Learn2(:, i) - L;
end;

% Learn the PQ code structure
fprintf('Learning the dataset\n');
tic
% pq = pq_new (nsq, Learn2');
ivfpq = ivfpq_new(coarsek, nsq, Learn2');
before_learn_time = toc

% encode the database vectors
fprintf('encoding the database\n');
tic
% cbase = pq_assign (pq, CD2');
ivf = ivfpq_assign(ivfpq, CD2');
before_enc_time = toc

%---[ perform the search and compare with the ground-truth ]---
fprintf('Searching the nearest neibogher\n');
tic
% [ID, d] = pq_search (pq, cbase, QD2', 1);
[ID, d] = ivfpq_search(ivfpq, ivf, QD2', k, w);
before_ANN_time = toc

clear cbase;

[P1 ,LQ, t_id, rec] = calc_acc(ID, QD2, CL, QL);

savRecPath = ['Results/', dataSet, '_n', num2str(n_of_extract), '_w', num2str(w), '_ivfpq.mat'];
save(savRecPath,'rec');

%% ERROR CALC
%{
[D1, D2, D3] = error_calc(LQ, SQ, QL, B);
% save('result_liner_orig_top30.mat', 'LQ'); %ï¿½ï¿½`, ï¿½ï¿½ï¿½Ì??¿½, top30ï¿½ï¿½ï¿½ï¿½ï¿½fï¿½[ï¿½^ï¿½xï¿½[ï¿½X, ï¿½cï¿½ï¿½ï¿½ï¿½Nï¿½Gï¿½ï¿½
save(['Results/', 'result_cross_orig_rand',n_of_extract ,'_pq.mat'], 'LQ', 'D1', 'D2', 'D3'); %flann, ï¿½ï¿½ï¿½Ì??¿½, random30ï¿½ï¿½ï¿½ï¿½ï¿½fï¿½[ï¿½^ï¿½xï¿½[ï¿½X, ï¿½cï¿½ï¿½ï¿½ï¿½Nï¿½Gï¿½ï¿½
%}

%% AFTER REGULARIZATION

CD3 = single(CD);
QD3 = single(QD);
Learn3 = single(Learn);
clear CD QD;

M = mean(CD3, 2);
for i = 1:256
    CD3(:, i) = CD3(:, i) - M;
end;

N = mean(QD3, 2);
for i = 1:256
    QD3(:, i) = QD3(:, i) - N;
end;

L = mean(Learn3, 2);
for i = 1:256
    Learn3(:, i) = Learn3(:, i) - L;
end;

% Learn the PQ code structure
fprintf('Learning the dataset\n');
tic
pq = pq_new(nsq, Learn3');
after_learn_time = toc

% encode the database vectors
fprintf('encoding the database\n');
tic
cbase = pq_assign(pq, CD3');
after_enc_time = toc

%---[ perform the search and compare with the ground-truth ]---
fprintf('Searching the nearest neibogher\n');
tic
[ID2, d2] = pq_search(pq, cbase, QD3', 1);
after_ANN_time = toc

clear cbase;

[P1 ,LQ, t_id, rec] = calc_acc(ID2, QD3, CL, QL);

savRecPath = ['Results/', dataSet, '_n', num2str(n_of_extract), '_w',num2str(w),'_pq.mat'];
save(savRecPath,'rec');


%% ERROR CALC
%{
% [D1, D2, D3] = error_calc(LQ, SQ, QL, B);
% save(['Results/', 'result_cross_avg_seiki_rand',n_of_extract ,'_pq.mat'], 'LQ', 'D1', 'D2', 'D3');
%}

%% irekae
% tic
% [ID, d] = flann_search(QD', CD' , 1, params);
% toc
% 
% [P1 ,LQ] = calc_acc(ID, CD, QL, CL);
% 
% tic
% [ID, d] = flann_search(QD2', CD2' , 1, params);
% toc
% 
% [P1 ,LQ] = calc_acc(ID, CD2, QL, CL);

%% ï¿½ï¿½ï¿½Uï¿½ï¿½ï¿½Kï¿½ï¿½
% 
% X1 = std(CD2, 1, 2);
% X2 = std(QD2, 1, 2);
% 
% Y1 = X1(:, ones(1,256));
% CD2 = CD2 ./ Y1;
% clear Y1;
% 
% Y2 = X2(:, ones(1,256));
% QD2 = QD2 ./ Y2;
% clear Y2;
% 
% tic
% [ID, d] = flann_search(CD2', QD2' , 1, params);
% toc
