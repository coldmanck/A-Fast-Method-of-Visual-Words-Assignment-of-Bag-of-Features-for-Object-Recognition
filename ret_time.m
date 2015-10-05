clear;
clc;

dataSet = 'Caltech101_biggest';
rt_result = fullfile('Results','time',dataSet);
files = dir([rt_result,'/*.mat']);

total_time = [];
for i=1:length(files)
    eval(['load ',rt_result,'/',files(i).name]);
    total_time = [total_time; t_c_num];
end
means = mean(total_time)

% sav_path = ['Results/time/',dataSet];
sav_path = ['Results/time/',dataSet, '_biggest'];
save([sav_path,'.mat'],'means');