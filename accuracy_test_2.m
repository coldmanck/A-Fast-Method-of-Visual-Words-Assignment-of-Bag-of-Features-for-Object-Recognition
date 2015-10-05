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
index_dir = 'index_101';
dataSet = 'Caltech101';

patch_size = 16;

params.algorithm = 'kdtree';
params.trees = 4;
params.checks = 256;

%% test the accuracy
% dict_path = 'Results\reg_sc_b1024_20090927T235404.mat';
% load(dict_path);

CD = [];
QD = [];

for ii = 1:100,
    fea_path = strcat(index_dir, '\', 'airplanes\image_', sprintf('%04d', ii), '.mat');
    load(fea_path);
    CD = [CD ; d];
end;

for ii = 1:10,
    fea_path = strcat(index_dir, '\', 'accordion\image_', sprintf('%04d', ii), '.mat');
    load(fea_path);
    QD = [QD ; d];
end;
    
tic
NS = ExhaustiveSearcher(CD);
IDX = knnsearch(NS, QD);
toc

tic
[I, D] = flann_search(CD', QD' , 1, params);
toc

M = length(QD);
p = 0;
for i = 1:M,
    if IDX(i) == I(i),
        p = p + 1;
    end;
end;

p = p / M;
fprintf('accuracy is %.3f%%\n\n', p*100);
