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
if skip_cal_sift,
    database = retr_database_dir(rt_data_dir);
else
    [database, lenStat] = Query_CalculateSiftDescriptor(rt_img_dir, rt_data_dir, gridSpacing, patchSize, maxImSize, nrml_threshold);
end;

%% load sparse coding dictionary
dict_path = 'Results\reg_sc_b1024_20090927T235404.mat';
load(dict_path);

%% calculate the sparse coding feature

label_dir = strcat('query_label');
if ~isdir(label_dir),
    mkdir(label_dir);
end;

dimFea = sum(nBases*pyramid.^2);
numFea = length(database.path);

sc_fea = zeros(dimFea, numFea);
sc_label = zeros(numFea, 1);

disp('==================================================');
fprintf('Calculating the sparse coding feature...\n');
fprintf('Regularization parameter: %f\n', gamma);
disp('==================================================');

for iter1 = 1:numFea,  
    if ~mod(iter1, 50),
        fprintf('.\n');
    else
        fprintf('.');
    end;
    fpath = database.path{iter1};
    load(fpath);
    if knn,
        sc_fea(:, iter1) = sc_approx_pooling(feaSet, B, pyramid, gamma, knn);
    else
        sc_fea(:, iter1) = sc_pooling(feaSet, B, pyramid, gamma, fpath);
    end
    sc_label(iter1) = database.label(iter1);
    
end;
