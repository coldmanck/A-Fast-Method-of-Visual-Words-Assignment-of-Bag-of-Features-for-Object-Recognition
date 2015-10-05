function [image_data, label_data, image_query, label_query, sift_query, image_learn] = cross_validation_pq(index_dir, data_dir, dataSet, n_of_extract)

%% set path
addpath('large_scale_svm');
addpath('sift');

%% parameter setting

% directory setup
% data_dir = 'data';                  % directory to save the sift features of the chosen dataset
% label_dir = 'label';
% index_dir = 'index_101';
% dataSet = 'Caltech101';

% patch_size = 16;
% n_of_extract = 30;

% rt_data_dir = fullfile(data_dir, dataSet);
rt_index_dir = fullfile(index_dir);
% rt_label_dir = fullfile(label_dir, dataSet);

%%
index = retr_database_dir(rt_index_dir);

%%

image_data  = [];
image_query = [];
label_data  = [];
label_query = [];
sift_query  = [];
image_learn = [];

for i = 1:index.nclass,%index.nclass
    D1 = [];
    L1 = [];
    D2 = [];
    L2 = [];
    S  = [];
    
    f_path = strcat(index_dir, '/', index.cname{i});
    l_path = retr_database_dir(f_path);
    ext = randsample(l_path.nclass, l_path.nclass);
    
    for j = 1:n_of_extract,
        path = strcat(f_path, '/', l_path.cname{ext(j)});
        load(path);
        D1 = [D1 ; d];
        L1 = [L1 ; IDX];
    end;
    image_data = [image_data ; D1];
    label_data = [label_data ; L1];
    image_learn= [image_learn ; d];
    clear D1 L1;
    
    %for j = (n_of_extract+1):l_path.nclass,
    for j = (n_of_extract+1):n_of_extract+5,
        path = strcat(f_path, '/', l_path.cname{ext(j)});
        s_path = strcat(data_dir, '/', dataSet, '/', index.cname{i}, '/', l_path.cname{ext(j)});
        load(path);
        load(s_path);
        D2 = [D2 ; d];
        L2 = [L2 ; IDX];
        S  = [S  ; (feaSet.feaArr)'];
    end;
    image_query = [image_query ; D2];
    label_query = [label_query ; L2];
    label_query = uint16(label_query);
    sift_query = [sift_query; S];
    clear D2 L2 S;
    
    fprintf('%d / %d complete\n', i, index.nclass);
%     fprintf('loaded %s\n', index.cname{i});
end;


% save('combined_index_images.mat', 'CD');
