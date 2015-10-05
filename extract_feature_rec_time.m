clear all;
clc;

%% set path
addpath('large_scale_svm');
addpath('sift');
addpath(genpath('sparse_coding'));

%% parameter setting

% directory setup
img_dir = 'query_image';                  % directory for dataset images
data_dir = 'query_data';                  % directory to save the sift features of the chosen dataset
dataSet = 'own_made';

% sift descriptor extraction
skip_cal_sift = false;              % if 'skip_cal_sift' is false, set the following parameter
gridSpacing = 6;
patchSize = 16;
maxImSize = 300;
nrml_threshold = 1;                 % low contrast region normalization threshold (descriptor length)

% dictionary training for sparse coding
skip_dic_training = true;
nBases = 1024;
nsmp = 200000;
beta = 1e-5;                        % a small regularization for stablizing sparse coding
num_iters = 50;

% feature pooling parameters
pyramid = [1, 2, 4];                % spatial block number on each level of the pyramid
gamma = 0.15;
knn = 0;                            % find the k-nearest neighbors for approximate sparse coding
                                    % if set 0, use the standard sparse coding

% classification test on the dataset
nRounds = 5;                        % number of random tests
lambda = 0.1;                       % regularization parameter for w
tr_num = 30;                        % training number per category

rt_img_dir = fullfile(img_dir, dataSet);
rt_data_dir = fullfile(data_dir, dataSet);

%% calculate sift features or retrieve the database directory
tic
if skip_cal_sift,
    database = retr_database_dir(rt_data_dir);
else
    [database, lenStat, D] = Query_CalculateSiftDescriptor_rec_time(rt_img_dir, rt_data_dir, gridSpacing, patchSize, maxImSize, nrml_threshold);
end;
toc
%% load sparse coding dictionary
dict_path = 'Results\reg_sc_b1024_20090927T235404.mat';
load(dict_path);

%% calculate the label of the features
params.algorithm = 'kdtree';
params.trees = 4;
params.checks = 256;

tic
[ID, d] = flann_search(B, D' , 1, params);
toc