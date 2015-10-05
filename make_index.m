clear all;
clc;

%% set path
addpath('large_scale_svm');
addpath('sift');
addpath(genpath('sparse_coding'));

%% parameter setting

% directory setup
% img_dir = 'image';                  % directory for dataset images
% data_dir = 'data';                  % directory to save the sift features of the chosen dataset
cropped_dir = 'cropped_images';
label_dir = 'label_t'; % Top 10 id of every patch of all pictre
index_dir = 'index';
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

%% load the cropped images
% cropped_dir = retr_cropped_dir(rt_cropped_dir);
label = retr_database_dir(rt_label_dir);
index = retr_database_dir(rt_index_dir);

%{
a = index.cname{2};
b = index.cname{3};
index.cname{2} = b;
index.cname{3} = a;
a = index.cname{43};
b = index.cname{44};
index.cname{43} = b;
index.cname{44} = a;
%}

n_of_crpd = 0;
n_of_i = 1;

j = 1;

%{
% in every class of dataset:
for ii = 1:index.nclass, %index.nclass
    index_path = strcat(index_dir, '/', index.cname{ii});
    load(index_path);
    l = length(L); % L ??
    L_10 = zeros(l, 10);
    m = 1;
    while m < l,
        str = strsplit(label.path{j}, '/');
        str1 = strcat(str{3}, '_index_1024.mat');
        if ~strcmp(str1, index.cname{ii}),
            break;
        end;
        load(label.path{j});
        ll = length(IDX);
        L_10(m:m+ll-1, 1:10) = IDX;
        clear IDX;
        m = m + ll;
        j = j + 1;
    end;
    new_index_path = strcat(index_dir, '_10/', index.cname{ii});
    save(new_index_path, 'D', 'L_10');
    clear D;
    clear L;
    clear L_10;
end;
%}

% read cropped_image 
for ii = 1:label.nclass, %class_dir.nclass
     index = strcat(index_dir, '/', label.cname{ii}, '_index_1024.mat');
     num_of_pic = 0;
     
     % if index already exist then skip
     if ~exist(index, 'file'),
         fprintf('Loading cropped images of %s ...', label.cname{ii});
         cropped = retr_cropped_dir(strcat(rt_cropped_dir, '/', label.cname{ii}));
         fprintf('Loaded %d images\n', cropped.imnum);
         D = zeros(cropped.imnum, patch_size^2);
         n_of_crpd = n_of_crpd + cropped.imnum;
         for jj = 1:cropped.imnum,
             I = imread(cropped.path{jj});
             D(jj,:) = I(:); % vectoralization
             clear I;
             %fprintf('Processing ... %.4f%%\n', (jj/cropped.imnum)*100);
         end;

         L = zeros(cropped.imnum, 1); % label vector
         m = 1;
         for ll = n_of_i:n_of_i+cropped.nclass-1, % n_of_i=1
             load(label.path{ll}); % (label.path = 1x9144 paths)
             n = length(IDX);
             L(m:(m+n-1), 1:10) = IDX;
             
             num_of_pic = num_of_pic + 1;
             sav_num = sprintf('%04d',num_of_pic);
             sav_dir = strcat(index_dir, '/', label.cname{ii});
             if ~isdir(sav_dir),
                mkdir(sav_dir);
             end;
             sav_path = strcat(index_dir, '/', label.cname{ii}, '/img_', sav_num, '.mat');
             D_sav = D(m:(m+n-1), 1:256);
             L_sav = L(m:(m+n-1), 1:10);
             save(sav_path, 'D_sav', 'L_sav');
             
             m = m + n;
         end;
         n_of_i = n_of_i+cropped.nclass; % in order to go to next class

         %save(index, 'D', 'L');

         clear D; % patches (256) 
         clear L; % label for each patch
         fprintf('Complete!\n');

     else
         fprintf('Skipping %s ...\n', label.cname{ii});
         cropped = retr_database_dir(strcat(rt_cropped_dir, '/', label.cname{ii}));
         n_of_i = n_of_i+cropped.nclass; % in order to go to next class
     end;
     clear cropped;

end;


%{
for ii = 1:label.imnum,
    load(label.path{ii});
    L = [L; IDX];
end;
%}

