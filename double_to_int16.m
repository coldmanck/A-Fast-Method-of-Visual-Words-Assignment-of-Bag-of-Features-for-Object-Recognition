clear all;
clc;

%% set path
addpath('large_scale_svm');
addpath('sift');
addpath(genpath('sparse_coding'));

%% parameter setting

% directory setup
img_dir = 'image';                  % directory for dataset images
data_dir = 'data';                  % directory to save the sift features of the chosen dataset
cropped_dir = 'cropped_images';
label_dir = 'label';
index_dir = 'index_10';
index_dir_s = 'index_10_int16';
dataSet = 'Caltech101';

patch_size = 16;

% rt_img_dir = fullfile(img_dir, dataSet);
% rt_data_dir = fullfile(data_dir, dataSet);
rt_cropped_dir = fullfile(cropped_dir);
rt_index_dir = fullfile(index_dir);
rt_label_dir = fullfile(label_dir, dataSet);

if ~isdir(index_dir),
    mkdir(index_dir);
end;

%%
index = retr_database_dir(rt_index_dir);

for i = 1:index.nclass,
    path = strcat('G:\Sotsuron\ScSPM\', index_dir, '\', index.cname{i});
    load(path);
    D = int16(D);
    L_10 = int16(L_10);
    path = strcat('G:\Sotsuron\ScSPM\', index_dir_s, '\', index.cname{i});
    save(path, 'D', 'L_10');
end;
