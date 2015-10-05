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
label_dir = 'label_2';
index_dir = 'index';
dataSet = 'Caltech101';

patch_size = 16;

% rt_img_dir = fullfile(img_dir, dataSet);
% rt_data_dir = fullfile(data_dir, dataSet);
rt_cropped_dir = fullfile(cropped_dir);
rt_index_dir = fullfile(index_dir);
rt_label_dir = fullfile(label_dir, dataSet);
rt_data_dir = fullfile(data_dir, dataSet);

if ~isdir(index_dir),
    mkdir(index_dir);
end;

%% load the cropped images
% cropped_dir = retr_cropped_dir(rt_cropped_dir);
% label = retr_database_dir(rt_label_dir);
% index = retr_database_dir(rt_index_dir);
data = retr_database_dir(rt_data_dir);

% %å¥énêl
% a = index.cname{2};
% b = index.cname{3};
% index.cname{2} = b;
% index.cname{3} = a;
% a = index.cname{43};
% b = index.cname{44};
% index.cname{43} = b;
% index.cname{44} = a;

% for i = 1:label.nclass,
%     CL = [];
%     for j = 1:label.imnum,
%         path = strcat('label_2\Caltech101\', label.cname{i}, '\image_', sprintf('%04d', j), '_label.mat');
%         if ~exist(path, 'file'),
%             savepath = strcat('label\Caltech101\0_combined\', label.cname{i}, '.mat');
%             save(savepath, 'CL');
%             break;
%         end;
%         load(path);
%         CL = [CL ; IDX];
%     end;
% end;

for i = 1:data.nclass,
    CF = [];
    for j = 1:data.imnum,
        path = strcat('data\Caltech101\', data.cname{i}, '\image_', sprintf('%04d', j), '.mat');
        if ~exist(path, 'file'),
            savepath = strcat('c_data\Caltech101\0_combined\', data.cname{i}, '.mat');
            save(savepath, 'CF');
            break;
        end;
        load(path);
        CF = [CF ; (feaSet.feaArr)'];
    end;
end;

% for i = 1:cropped_dir.nclass,%cropped_dir.nclass
%     D = [];
%     path = strcat('G:\Sotsuron\ScSPM\cropped_images\', cropped_dir.cname{i});
%     cropped = retr_cropped_dir(path);
%     for j = 1:cropped.imnum,
%         I = imread(cropped.path{j});
%         D = [D ; (I(:))'];
%     end;
%     save_path = strcat('G:\Sotsuron\ScSPM\', index_dir, '\index_', cropped_dir.cname{i}, '.mat');
%     save(save_path, 'D');
%     fprintf('complete %d / %d\n', i, cropped_dir.nclass);
% end;