function [image_data, label_data, image_query, label_query, extract, data_svm, query_svm, svm_label_data, svm_label_query, num_of_cropped] = cross_validation_svm(N, index_dir, n_of_extract, n_of_id, dataSet)

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
% n_of_extract = 5;

% rt_data_dir = fullfile(data_dir, dataSet);
rt_index_dir = fullfile(index_dir);
% rt_label_dir = fullfile(label_dir, dataSet);

%%
index = retr_database_dir(rt_index_dir);

%%
% load('extracted_random30.mat');
% load('extracted_random15.mat');

image_data = [];
image_query = [];
label_data = [];
label_query = [];
% sift_query = [];
data_svm = [];
query_svm = [];

% number of pictures
% extract = struct('ext', {});
num_of_cropped = [];
svm_label_data = [];
svm_label_query =[];
y = linspace(1, 1024, 1024);

for i = 1:index.nclass,%index.nclass
    D1 = [];
    L1 = [];
    D2 = [];
    L2 = [];
    
    % f_path: index_101/
    f_path = strcat(index_dir, '/', index.cname{i});
    l_path = retr_database_dir(f_path);
    ext = randsample(l_path.nclass, l_path.nclass);
%     ext = linspace(1, l_path.nclass, l_path.nclass);
    
    extract(i).ext = ext;
%     ext = extract(i).ext;
    
    % making SVM + database of learning data, where N is the size of table
    for j = 1:N,
        path = strcat(f_path, '/', l_path.cname{ext(j)});
        load(path);
        n = zeros(1, 1024);
        for ii = 1:n_of_id,
            n_t = hist(IDX(:, ii), y);
            n = n + n_t;
        end;
        data_svm = [data_svm ; n];
        IDX = uint16(IDX);
        svm_label_data = [svm_label_data ; i];
        D1 = [D1 ; d];
        L1 = [L1 ; IDX];
    end;
    image_data = [image_data ; D1];
    label_data = [label_data ; L1];
    clear D1 L1;
    
    % only making SVM of learning data
     for j = N+1:n_of_extract,
         path = strcat(f_path, '/', l_path.cname{ext(j)});
         load(path);
         n = zeros(1, 1024);
         for ii = 1:n_of_id,
             n_t = hist(IDX(:, ii), y);
             n = n + n_t;
         end;
         data_svm = [data_svm ; n];
         IDX = uint16(IDX);
         svm_label_data = [svm_label_data ; i];
     end;
    
    % making SVM + database of query data
    %for j = (n_of_extract+1):l_path.nclass
    for j = (n_of_extract+1):n_of_extract+1
        path = strcat(f_path, '/', l_path.cname{ext(j)});
        load(path);
        n = zeros(1, 1024);
        for ii = 1:n_of_id,
            n_t = hist(IDX(:, ii), y);
            n = n + n_t;
        end;
        query_svm = [query_svm ; n];
        svm_label_query = [svm_label_query ; i];
        num_of_cropped = [num_of_cropped, length(IDX)];
        D2 = [D2 ; d];
        L2 = [L2 ; IDX];
    end;
    image_query = [image_query; D2];
    label_query = [label_query; L2];
    clear D2 L2;
    
    fprintf('%d / %d complete\n', i, index.nclass);
%     fprintf('loaded %s\n', index.cname{i});
end;

ex_path = [dataSet, '_svm_extracted_random_', num2str(n_of_extract), '.mat'];
save(ex_path, 'extract');
% save('combined_index_images.mat', 'CD');
