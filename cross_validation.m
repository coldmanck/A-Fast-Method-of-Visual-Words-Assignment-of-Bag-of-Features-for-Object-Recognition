function [image_data, label_data, image_query, label_query, sift_query] = cross_validation(index_dir, dataSet, n_of_extract)

%% set path
addpath('large_scale_svm');
addpath('sift');

%% parameter setting

% directory setup
data_dir = 'data';  % directory to save the sift features of the chosen dataset
% label_dir = 'label';
% index_dir = 'index_101';
% dataSet = 'Caltech101';

% patch_size = 16;
% n_of_extract = 15;

% rt_data_dir = fullfile(data_dir, dataSet);
rt_index_dir = fullfile(index_dir);
% rt_label_dir = fullfile(label_dir, dataSet);

%%
index = retr_database_dir(rt_index_dir);

%%
extract = struct('ext', {});
image_data = [];
image_query = [];
label_data = [];
label_query = [];
sift_query = [];

fprintf('total image number of the database: %d, total class: %d\n', index.imnum, index.nclass);
fprintf('for each class:\n');
for i = 1:index.nclass,
    fprintf('name: %s, label: %s, path:%s\n',index.cname{i},index.label(i),index.path{i});
end;

for i = 1:index.nclass,
    D1 = []; % Data for database
    L1 = []; % Label for database
    D2 = []; % Data for query
    L2 = []; % Label for query
    S  = []; % sift query
    
    % l_path: class
    f_path = strcat(index_dir, '/', index.cname{i});
    l_path = retr_database_dir(f_path);
    
    % randsample(n,k) returns a k-by-1 vector y of values sampled uniformly at random, 
    % without replacement, from the integers 1 to n.
    % Anyway, put 1~l_path.nclass into an l_path.nclass*1 vector randomly.
    ext = randsample(l_path.nclass, l_path.nclass);
    
    extract(i).ext = ext;
%     ext = extract(i).ext;
    
    % take index 1~n_of_extract as database, image_data & label_data
    for j = 1:n_of_extract,
        path = strcat(f_path, '/', l_path.cname{ext(j)});
        load(path);
        IDX = uint16(IDX);
        D1 = [D1 ; d];
        L1 = [L1 ; IDX];
    end;
    image_data = [image_data ; D1];
    label_data = [label_data ; L1];
    clear D1 L1;
    
    % take index n_of_extract+1~ as database, image_query & label_query
    %for j = (n_of_extract+1):l_path.nclass,
    % for j = (n_of_extract+1):l_path.nclass,%n_of_extract+15
     for j = (n_of_extract+1):n_of_extract+3
        path = strcat(f_path, '/', l_path.cname{ext(j)});
        s_path = strcat(data_dir, '/', dataSet, '/', index.cname{i}, '/', l_path.cname{ext(j)});
        load(path);
        load(s_path);
        IDX = uint16(IDX);
        D2 = [D2 ; d];
        L2 = [L2 ; IDX];
        S  = [S  ; (feaSet.feaArr)'];
    end;
    image_query = [image_query ; D2];
    label_query = [label_query ; L2];
    sift_query = [sift_query; S];
    clear D2 L2 S;
    
    fprintf('%d / %d complete\n', i, index.nclass);
%     fprintf('loaded %s\n', index.cname{i});
end;

% saved as "extract_random_?.mat"
save_path = strcat('Results/extract/',dataSet, '_extracted_random_', sprintf('%d.mat', n_of_extract));
if ~isdir('Results/extract')
   mkdir('Results/extract');
end
save(save_path, 'extract');
% save('combined_index_images.mat', 'CD');
