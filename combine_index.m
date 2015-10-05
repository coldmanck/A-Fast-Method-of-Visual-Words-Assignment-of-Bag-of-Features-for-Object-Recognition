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

%å¥énêl
a = index.cname{2};
b = index.cname{3};
index.cname{2} = b;
index.cname{3} = a;
a = index.cname{30};
b = index.cname{31};
index.cname{30} = b;
index.cname{31} = a;
a = index.cname{43};
b = index.cname{44};
index.cname{43} = b;
index.cname{44} = a;

N = 0;
CD = [];
CL = [];

for i = 1:index.nclass,%index.nclass
    path = strcat(index_dir, '\', index.cname{i});
    load(path);
    D = single(D);
    CD = [CD; D];
%     CL = [CL; L_10];
    fprintf('loaded %s\n', index.cname{i});
end;

% m = 1;
% for i = 1:index.nclass,
%     path = strcat('G:\Sotsuron\ScSPM\', index_dir, index.cname{i});
%     load(path);
%     l = length(L);
%     CD(m:(m+l-1), :) = D;
%     CL(m:(m+l-1), :) = L;
%     m = m + l;
% end;

% save('combined_index_images.mat', 'CD');