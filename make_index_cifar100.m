clear all;
clc;

dataSet = 'cifar-100';
label_file = 'label_3';
cropped_images_file = 'cropped_images';

rt_label_path = fullfile(label_file, dataSet);
% rt_pic_path = fullfile(cropped_images_file);
rt_pic_path = fullfile(cropped_images_file, dataSet);
label_p = dir([rt_label_path,'/']);
cropped_images_p = dir([rt_pic_path,'/']);

label_path = [];
for i = 3:length(label_p)
    %fprintf(label_p(i).name)
    label_path_temp = fullfile(label_p(i).name);
    label_files = dir([rt_label_path, '/', label_path_temp,'/*.mat']);
    pic_files_dir = dir([rt_pic_path, '/', label_path_temp,'/*']);
    for j = 1:length(label_files)
        d = [];
        pic_files = dir([rt_pic_path, '/', label_path_temp,'/', pic_files_dir(j+2).name, '/*.jpg']);
        eval(['load ',rt_label_path,'/',label_path_temp,'/',label_files(j).name]);
        for k = 1:length(pic_files)
            I = imread([rt_pic_path,'/',label_path_temp,'/',pic_files_dir(j+2).name,'/', pic_files(k).name]);
            L = length(I);
            D = zeros(1,L^2);
            temp = 1;
            for l = 1:L
               D(1,temp:temp+L-1) = I(l,:);
               temp = temp + L;
            end
            d = [d; D];
        end
        sav_path = ['index', '/',dataSet, '/', label_path_temp];
        if ~isdir(sav_path);
            mkdir(sav_path);
        end
        save([sav_path, '/', pic_files_dir(j+2).name,'.mat'],'IDX','d');
        clear d;
        %eval(['load ',rt_pic_path,'/',label_path_temp,'/',pic_files(j).name]);
        %total_time = [total_time; t_c_num];
    end
    
    %label = dir([label_p,'/*.mat']);
    %cropped_images = dir([cropped_images_p,'/*.mat']);
end
