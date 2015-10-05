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
img_dir = 'query_image';                  % directory for dataset images
data_dir = 'query_data';                  % directory to save the sift features of the chosen dataset
cropped_dir = 'cropped_images_query';
label_dir = 'query_label_2';
index_dir = 'index_10';
dataSet = 'own_made';

patch_size = 16;

% define index and search parameters
build_params.algorithm = 'autotuned';
build_params.target_precision = 0.9;
build_params.build_weight = 0.01;
build_params.memory_weight = 0;

params.algorithm = 'kdtree';
params.trees = 4;
params.checks = 256;


rt_cropped_dir = fullfile(cropped_dir);
rt_label_dir = fullfile(label_dir, dataSet);

%%
class_dir = retr_cropped_dir(rt_cropped_dir);
label = retr_database_dir(rt_label_dir);
% index_p = retr_database_dir(rt_index_dir);

dict_path = 'Results/reg_sc_b1024_20090927T235404.mat';
load(dict_path);

% index = strcat(index_dir, '/', class_dir.cname{1}, '_index_1024.mat');
% load(index);

% load('G:\Sotsuron\ScSPM\index_10\BACKGROUND_Google_index_1024.mat');
% load('G:\Sotsuron\ScSPM\index_10\airplanes_index_1024.mat');
% load('G:\Sotsuron\ScSPM\index_10\accordion_index_1024.mat');
% load('G:\Sotsuron\ScSPM\combined_index_1024_1to5_avg_seiki.mat');

% load('query_motorbike_own.mat');
% load('query_motorbike_own_norm_seikika.mat');
load('query_motorbike_own_avg_seikika.mat');
% load('combined_index_1024.mat');
% load('combined_index_1024_norm_seikika.mat');
load('combined_index_1024_avg_seikika.mat');

% tic
% NS = KDTreeSearcher(D, 'distance', 'euclidean');
% ID = knnsearch(NS, C);
% toc

% tic
% NS = ExhaustiveSearcher(D);
% ID = knnsearch(NS, C);
% toc

% fprintf('Calculating the opt_par\n');
% tic
% [ind, parameters] = flann_build_index(D', build_params);
% toc

% for ann search
% CD = double(CD);
% CL = double(CL);

fprintf('Searching the nearest neibogher\n');
tic
% [D, ID] = pdist2(CD, C, 'euclidean', 'Smallest',1);
% [ID, d] = annsearch(CD', C', 1, 'errbound', 5);
[ID, d] = flann_search(CD', C' , 10, params);
toc

l = length(C);
LS = zeros(l, 1024);
for i = 1:l,
    for j = 1:10,
        m = ID(j, i);
        for k = 1:10,
            h = CL(m, k);
            LS(i, h) = LS(i, h) + (100-j^2+1)/100;
        end;
    end;
end;

[M , LQ] = max(LS, [], 2);

P = zeros(1, 10);
for i = 1:l,
    for j = 1:10
        if LQ(i) == L(i, j),
            P(j) = P(j) + 1;
        end;
    end;
end;

p = 0;
for i = 1:10,
    p = p + P(i)/l;
    %     fprintf('accuracy is %.03f%% (N=%d)\n', 100 * p, i);
    fprintf('%.03f\n', p);
end;
