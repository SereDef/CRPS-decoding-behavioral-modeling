%%                       GROUP DECODING

% This script runs the second level (group) analysis based on first level results,
% can be easily costumed with respect to the comparisons of interest.

% - Results folder needs to be organized so that each group (condition or side)
% - has the "ALL_NOSELCTION" folder nested within containig all the individual 
% - data belonging to the gorup. That is if no channel selection was adopted.

% check ADAM toolbox documentation for more info on each parameter

%% main settings

cfg.startdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\TGM'; % change to 1st lvl results folder
cfg.mpcompcor_method = 'cluster_based';  % cluster-based permutation test for significance
cfg.iterations = 1000;               % nr of iterations in the cluster based permutation
%cfg.plotsubjects = true;            % single subject decoding plots to check for quality
%cfg.splinefreq = 40;                % Hz low-pass filter cause single subject is hella messy
cfg.reduce_dims = '';                % compute time-by-time: extracts the entire TGM, 
                                     % change to "diag" for only point to point timecourse
cfg.trainlim = [-100 500];           % specify a ms interval in the training data


% cost the variables according to the comparisons of interest
% e.g. here active healthy volunteers left and so on...
% aHV_left = adam_compute_group_MVPA(cfg);  %select the appropriate folder
% aHV_right = adam_compute_group_MVPA(cfg);
% aCRPS_aff = adam_compute_group_MVPA(cfg);  %select the appropriate folder
% aCRPS_unaff = adam_compute_group_MVPA(cfg);
% 
% pHV_left = adam_compute_group_MVPA(cfg);  %select the appropriate folder
% pHV_right = adam_compute_group_MVPA(cfg);
% pCRPS_aff = adam_compute_group_MVPA(cfg);  %select the appropriate folder
% pCRPS_unaff = adam_compute_group_MVPA(cfg);

aHV = adam_compute_group_MVPA(cfg);
pHV = adam_compute_group_MVPA(cfg);
aCRPS = adam_compute_group_MVPA(cfg);
pCRPS = adam_compute_group_MVPA(cfg);

%% saving the statistics into a txt file
adam_savepstructs(cfg, aHV, aCRPS, pHV, pCRPS); % costume according to comparisons
                                                % it saves the .txt in the dir folder

%% plotting settings

cfg.singleplot = true;   % if you want to plot more than one group result together
cfg.timetick = 100;       % changes time tickmarks to 300 ms.
%cfg.splinefreq = 80;     % smooths the timecourse, only for presentation
cfg.acclim2D = [.40 .60]; % modifies the y-limits
%cfg.line_colors = {[.3 .3 1], [.6 1 .6], [1 0 0], [1 .6 .6]}; 
%cfg.line_colors = {[.3 .8 .3], [.3 .3 1]}; % light blue and green
%cfg.line_colors = {[.9 .8 .3], [.8 0 0]}; % yeloow-ish and dark red                 

% actual plotting
%adam_plot_MVPA(cfg, pCRPS_aff, aCRPS_aff, pCRPS_unaff, aCRPS_unaff); % change with the group of interest, as many as you whant in the same plot
adam_plot_MVPA(cfg, pHV, aHV, pCRPS, aCRPS);

%% 
%% Compare groups
comp_p = adam_compare_MVPA_stats(cfg, pHV, pCRPS);
comp_a = adam_compare_MVPA_stats(cfg, aHV, aCRPS);

% an plot the comparison timecourse
adam_plot_MVPA(cfg, comp_a);

%%
%%
%% the end :)

