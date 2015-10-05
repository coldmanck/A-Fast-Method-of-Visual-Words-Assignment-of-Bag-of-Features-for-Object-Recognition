clear all;
clc;

%% set path
addpath('large_scale_svm');
addpath('sift');
addpath(genpath('sltoolbox'));
addpath(genpath('flann-1.8.4-src'));
addpath(genpath('sparse_coding'));
addpath(genpath('libsvm-3.20/matlab'));

%% parameter setting

% directory setup
% data_dir = 'data';                  % directory to save the sift features of the chosen dataset
dataSet = 'Caltech101';
index_dir = ['index/',dataSet];

patch_size = 16;
n_of_extract = 30;   % M , default: 15 ?
N = 5; % N <= n_of_extract (M)
k = 1; % k-nearest neighbor

% define index and search parameters
build_params.algorithm = 'autotuned';
build_params.target_precision = 0.7;
build_params.build_weight = 0.01;
build_params.memory_weight = 1;

params.algorithm = 'kdtree';
params.trees = 4;
params.checks = 256;


%%
% index_p = retr_database_dir(rt_index_dir);

% dict_path = 'Results/reg_sc_b1024_20090927T235404.mat';
% load(dict_path);

% for ann search
fprintf('making database and query\n');

[CD, CL, QD, QL, ext, data, query, data_label, query_label, num_of_cropped] = cross_validation_svm(N, index_dir, n_of_extract, k, dataSet);
% CD, QD: all patch vectores of all database/query (d)
% CL, QL: id of top 10 near centroid of all patches of all database/query (IDX)
% data, query, data_label, query_label: used by SVM
% num_of_cropped: number of patches every query picture


fprintf('Searching the nearest neibogher\n');
% IND = flann_build_index(CD', params);
% tic
% % [D, ID] = pdist2(CD, C, 'euclidean', 'Smallest',1);
% % [ID, d] = annsearch(CD', C', 1, 'errbound', 5);
% % [IND, parameters] = flann_build_index(CD', build_params);
% % [ID, d] = flann_search(IND, C' , 1);
% [ID, d] = flann_search(CD', QD' , 1, params);
% toc
% 
% [P1 ,LQ] = calc_acc(ID, QD, CL, QL);

% [D1, D2, D3] = error_calc(LQ, SQ, QL, B);

% save('result_liner_orig_top30.mat', 'LQ'); %??, ????, top30????????, ??????
% save('result_cross_orig_rand1_try5.mat', 'LQ', 'D1', 'D2', 'D3'); %flann, ????, random30????????, ??????

%% ?????
CD = single(CD);
QD = single(QD);

M = mean(CD, 2);
for i = 1:256
    CD(:, i) = CD(:, i) - M;
end;

N = mean(QD, 2);
for i = 1:256
    QD(:, i) = QD(:, i) - N;
end;

tic
[ID, d] = flann_search(CD', QD' , 1, params);
t_ = toc;

[P1, LQ, t_id] = calc_acc(ID, QD, CL, QL);

%% make histogram of query
y = linspace(1, 1024, 1024);
query_from_patch = [];
% num_of_cropped: number of patches every query picture
NN = length(num_of_cropped); % N = number of query pictures
tic
for i = 1:NN, % for every query picture:
    m = num_of_cropped(i); % number of patches of every picture
    n = zeros(1, 1024);
    for ii = 1:k, % now k = 1
        L = LQ(1:m, ii); % LQ: id of the nearset patch found by FLANN
        n_t = hist(L, y); % n_t is an 1x1024 double vector
        n = n + n_t; % histogram (frequency) (1x1024, for just one k)
    end;
    LQ(1:m, :) = [];
    query_from_patch = [query_from_patch; n];
end;
t_hist = toc;

%% SVM's scaling

%find the maximum number of data array
Max = max(data);
M = max(Max);

data = data/M;
query = query/M;
query_from_patch = query_from_patch/M;

%% SVM
% data: (number of pics)(102xN) * 1024 matric
% label: (number of pics)(102xN) * 1 matric
% query: (number of pics)(102xN) * 1024 matric

%# grid of parameters
folds = 5;
[C,gamma] = meshgrid(-5:2:15, -15:2:3);

%# grid search, and cross-validation
tic
cv_acc = zeros(numel(C),1);
for i=1:numel(C)
    cv_acc(i) = svmtrain(data_label, data, sprintf('-c %f -g %f -v %d', 2^C(i), 2^gamma(i), folds));
end
t_find_p = toc;

%# pair (C,gamma) with best accuracy
[~,idx] = max(cv_acc);

%# now you can train you model using best_C and best_gamma
best_C = 2^C(idx);
best_gamma = 2^gamma(idx);

tic
SVM = svmtrain(data_label, data, sprintf('-c %f -g %f', 2^C(i), 2^gamma(i)));
t_train = toc;
tic
[predicted_label, acc, dic_value] = svmpredict(query_label, query, SVM);
t_pre1 = toc;
tic
[predicted_label_p, acc_p, dic_value_p] = svmpredict(query_label, query_from_patch, SVM);
t_pre2 = toc;

fprintf('Best C = 2^%d, Best gamma = 2^%d\n', C(idx), gamma(idx));
fprintf('Find P: %f, train: $f, pre1: %f, pre2: %f.\n', t_find_p, t_train, t_pre1, t_pre2);

save(['query_test_svm_para_M', num2str(n_of_extract), '_N', num2str(N),'.mat'], 'SVM', 'predicted_label', 'acc', 'dic_value', 'predicted_label_p', 'acc_p', 'dic_value_p');
% [D1, D2, D3] = error_calc(LQ, SQ, QL, B);

% save('result_cross_avg_seiki_rand1_try5.mat', 'LQ', 'D1', 'D2', 'D3'); 

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
