% function [image_data, label_data, image_query, label_query, sift_query] = cross_validation(index_dir, data_dir, dataSet)

%% set path
addpath('large_scale_svm');
addpath('sift');

%% parameter setting

% directory setup
data_dir = 'data';                  % directory to save the sift features of the chosen dataset
label_dir = 'label';
index_dir = 'index_101';
dataSet = 'Caltech101';

% patch_size = 16;
n_of_extract = 30;

% rt_data_dir = fullfile(data_dir, dataSet);
rt_index_dir = fullfile(index_dir);
% rt_label_dir = fullfile(label_dir, dataSet);

%%
index = retr_database_dir(rt_index_dir);

%%

image_data = [];
image_query = [];
label_data = [];
label_query = [];
sift_query = [];

for i = 1:index.nclass,%index.nclass
    f_path = strcat(index_dir, '\', index.cname{i});
    l_path = retr_database_dir(f_path);
    ext = randsample(l_path.nclass, l_path.nclass);
    for j = 1:n_of_extract,
        path = strcat(f_path, '\', l_path.cname{ext(j)});
        s_path = strcat(data_dir, '\', dataSet, '\', index.cname{i}, '\', l_path.cname{ext(j)});
        load(path);
        load(s_path);
        if length(d) ~= length(feaSet.feaArr),
            fprintf('%s\n', s_path);
        end;
%         image_data = [image_data ; d];
%         label_data = [label_data ; IDX];
%         sift_query = [sift_query; (feaSet.feaArr)'];
    end;
    for j = (n_of_extract+1):l_path.nclass,
        path = strcat(f_path, '\', l_path.cname{ext(j)});
        s_path = strcat(data_dir, '\', dataSet, '\', index.cname{i}, '\', l_path.cname{ext(j)});
        load(path);
        load(s_path);
        if length(d) ~= length(feaSet.feaArr),
            fprintf('%s\n', s_path);
        end;
%         image_query = [image_query ; d];
%         label_query = [label_query ; IDX];
    end;
%     fprintf('loaded %s\n', index.cname{i});
end;


% save('combined_index_images.mat', 'CD');