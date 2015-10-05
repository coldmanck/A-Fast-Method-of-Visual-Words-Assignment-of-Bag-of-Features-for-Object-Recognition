% This is an example code for running the ScSPM algorithm described in "Linear 
% Spatial Pyramid Matching using Sparse Coding for Image Classification" (CVPR'09)
%
% Written by Jianchao Yang @ IFP UIUC
% For any questions, please email to jyang29@ifp.illinois.edu.
% 
% Revised May, 2010 by Jianchao Yang

clear all;
clc;

%% set path
addpath('Results');

%% parameter setting

% directory setup
rst_dir = 'Results';                  % directory for dataset images

rt_rslt_dir = fullfile(rst_dir);

%%
result = retr_database_dir(rt_rslt_dir);

for i = 1:result.imnum,
    % a = Results/result_cross_vali_/result_cross_avg_seiki_rand5_try5.mat
    a = result.path{i};
    b = strsplit(a, {'/', '.'});
    c = strcat(b(1), '/', b(2), '/', b(3));
    c = char(c);
    if ~isdir(c),
        mkdir(c);
    end;
    
    xvalues = linspace(0, 2, 50);
    load(a);
    figure;
    
    % d
    hist(D1, xvalues);
    axis([0 2 0 1]);
    axis 'auto y';
    sav = strcat(c, '/', b(3), '_D1.eps');
    sav = char(sav);
    saveas(gcf, sav);
    
    hist(D2, xvalues);
    axis([0 2 0 1]);
    axis 'auto y';
    sav = strcat(c, '/', b(3), '_D2.eps');
    sav = char(sav);
    saveas(gcf, sav);
    
    hist(D3, xvalues);
    axis([0 2 0 1]);
    axis 'auto y';
    sav = strcat(c, '/', b(3), '_D3.eps');
    sav = char(sav);
    saveas(gcf, sav);
    
    close;
end;
    