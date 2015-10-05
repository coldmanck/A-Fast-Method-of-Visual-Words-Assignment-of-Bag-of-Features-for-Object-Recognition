clear all;
clc;

%% set path
addpath('large_scale_svm');
addpath('sift');
addpath(genpath('sltoolbox'));
addpath(genpath('flann-1.8.4-src'));
addpath(genpath('sparse_coding'));

%% parameter setting

% directory setup
% data_dir = 'data'; % directory to save the sift features of the chosen dataset
% index_dir = 'index'
dataSet = 'Caltech256';
index_dir = ['index/',dataSet];

patch_size = 16;
n_of_extract = 15;

% (FLANN) define index and search parameters
build_params.algorithm = 'autotuned';
build_params.target_precision = 0.7;
build_params.build_weight = 0.01;
build_params.memory_weight = 1; 

params.algorithm = 'kdtree';
params.trees = 4;
params.checks = 256;

%% make database and query
% index_p = retr_database_dir(rt_index_dir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT IF 'B' USED %%%%%%%%%
% dict_path = 'Results/reg_sc_b1024_20090927T235404.mat';
% load(dict_path);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% index = strcat(index_dir, '/', class_dir.cname{1}, '_index_1024.mat');
% load(index);

% load('query_motorbike_own.mat');
% load('query_motorbike_own_norm_seikika.mat');
% load('query_motorbike_own_avg_seikika.mat');
% load('combined_index_1024.mat');
% load('combined_index_1024_norm_seikika.mat');
% load('combined_index_1024_avg_seikika.mat');
% load('cross_dev_dataset_30_images.mat');
% load('cross_dev_query_30_images.mat');

% tic
% NS = KDTreeSearcher(D, 'distance', 'euclidean');
% ID = knnsearch(NS, C);
% toc

% tic
% NS = ExhaustiveSearcher(CD);
% ID = knnsearch(NS, QD);
% toc

% fprintf('Calculating the opt_par\n');
% tic
% [ind, parameters] = flann_build_index(D', build_params);
% toc

% for ann search
% CD = double(CD);
% CL = double(CL);
fprintf('making database and query...\n')
[CD, CL, QD, QL, SQ] = cross_validation(index_dir, dataSet, n_of_extract);

% CD: array that comprise all database vectors
% CL: array that comprise ten of the most recent id of CD.
%{
fprintf('writing into ''orignal.csv''...\n')
csvwrite('orignal.csv', CD);
%}

%% Search the nearest neibogher
%{
fprintf('Searching the nearest neibogher...\n')

% IND = flann_build_index(CD', params);
tic
[ID, d] = flann_search(CD', QD' , 1, params);
toc

[P1 ,LQ] = calc_acc(ID, QD, CL, QL);

%% error calculate
fprintf('calculating d1, d2 and d3...\n')
[D1, D2, D3] = error_calc(LQ, SQ, QL, B);

savPath1 = ['result_cross_avg_regular_retr',n_of_extract,'.mat'];
savPath2 = ['result_cross_avg_retr',n_of_extract,'.mat'];
isRegular = 0;
if isRegular
    save(savPath1, 'LQ', 'D1', 'D2', 'D3'); 
else
    save(savPath2, 'LQ', 'D1', 'D2', 'D3'); 
end

% save('result_liner_orig_top30.mat', 'LQ'); %??, ????, top30????????, ??????
% save('result_cross_orig_rand1_try5.mat', 'LQ', 'D1', 'D2', 'D3'); %flann, ????, random30????????, ??????
%}
%% After regularization
% convert to single precision
CD2 = single(CD);
QD2 = single(QD);

% regularization
% mean(X, 2) -> 2 refer to two-dimension's mean and get row-mean
% mean func. will output column-mean if not specified
M = mean(CD2, 2);
for i = 1:256
    CD2(:, i) = CD2(:, i) - M;
end;

N = mean(QD2, 2);
for i = 1:256
    QD2(:, i) = QD2(:, i) - N;
end;
%{
fprintf('Wrinting into ''avg_sep.csv''...')
csvwrite('avg_sep.csv', CD2);
fprintf('OVER!!\n')
%}
fprintf('(After regularized) Searching the nearest neibogher...\n')
tic
[ID, d] = flann_search(CD2', QD2' , 1, params);
fprintf('At FLANN searching:')
flann_time = toc

[P1, LQ, t_id, rec] = calc_acc(ID, QD2, CL, QL);

savRecPath = ['Results/', dataSet, '_n', num2str(n_of_extract), '_kd', num2str(params.trees), '.mat'];
save(savRecPath,'rec');

savTimePath = ['Results', '/', 'flann_t'];
if ~isdir(savTimePath)
    mkdir(savTimePath);
end
save([savTimePath, '/', dataSet, '_n', num2str(n_of_extract), '.mat'], 'flann_time');

%% error calculate
%{
fprintf('calculating d1, d2 and d3...\n')
[D1, D2, D3] = error_calc(LQ, SQ, QL, B);

savPath1 = ['result_cross_avg_regular_retr',n_of_extract,'.mat'];
savPath2 = ['result_cross_avg_retr',n_of_extract,'.mat'];
isRegular = 1;
if isRegular
    save(savPath1, 'LQ', 'D1', 'D2', 'D3'); 
else
    save(savPath2, 'LQ', 'D1', 'D2', 'D3'); 
end

% save('result_cross_avg_seiki_rand1_try5.mat', 'LQ', 'D1', 'D2', 'D3'); 
%}


%% ????
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

%% ?????
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
