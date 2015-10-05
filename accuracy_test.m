clear all;
clc;

%% set path
addpath('large_scale_svm');
addpath('sift');
addpath(genpath('sparse_coding'));
addpath(genpath('sltoolbox'));

%% parameter setting

% directory setup
img_dir = 'image';                  % directory for dataset images
data_dir = 'data';                  % directory to save the sift features of the chosen dataset
cropped_dir = 'cropped_images';
label_dir = 'label';
index_dir = 'index';
dataSet = 'Caltech101';

patch_size = 16;

%% test the accuracy
dict_path = 'Results\reg_sc_b1024_20090927T235404.mat';
load(dict_path);

for ii = 1:10,
    fea_path = strcat(data_dir, '\', dataSet, '\accordion\image_', sprintf('%04d', ii), '.mat');
    load(fea_path);
    B = single(B);
    feaSet.feaArr = single(feaSet.feaArr);
    
    tic
    NS = ExhaustiveSearcher(B');
    IDX = knnsearch(NS, feaSet.feaArr');
    toc
    
    tic
%     [I, D] = annsearch(B, feaSet.feaArr, 1, 'errbound', 0.1);
    [D, I] = pdist2(B', feaSet.feaArr', 'euclidean', 'Smallest',1);
    toc
    
    M = length(feaSet.feaArr);
    p = 0;
    for i = 1:M,
        if IDX(i) == I(i),
            p = p + 1;
        end;
    end;
    
    p = p / M;
    fprintf('accuracy is %.3f%%\n\n', p*100);
    
end