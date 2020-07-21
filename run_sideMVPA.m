%%                       SIDE STATS HV

cfg = [];
cfg.startdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\'; % results folder
cfg.mpcompcor_method = 'uncorrected';   % or 'cluster_based';
cfg.iterations = 1000;                  % reduce nr of iterations in the cluster based permutation
%cfg.plotsubjects = true;               % single subject decoding plots
%cfg.splinefreq = 40;                   % Hz low-pass filter cause single subject is hella messy
cfg.reduce_dims = 'diag';               % training and testing on the same points
                                        % change to '' to compute time-by-time: extracts the entire TGM
cfg.trainlim = [-95 500];               % specify a ms interval in the training data

aHV_left = adam_compute_group_MVPA(cfg);  %select the appropriate thing
aHV_right = adam_compute_group_MVPA(cfg);

pHV_left = adam_compute_group_MVPA(cfg);  %select the appropriate thing
pHV_right = adam_compute_group_MVPA(cfg);

aCRPS_aff = adam_compute_group_MVPA(cfg);  %select the appropriate thing
aCRPS_unaff = adam_compute_group_MVPA(cfg);

pCRPS_aff = adam_compute_group_MVPA(cfg);  %select the appropriate thing
pCRPS_unaff = adam_compute_group_MVPA(cfg);

%%

%% smooth a bit and plot results

cfg.splinefreq = 85;        % just to visualize
cfg.singleplot = true;      % all analyses plot in a single figure
cfg.timetick = 50;          % changes time tickmarks to 300 ms.
cfg.acclim2D = [.16 .32];   % modifies the y-limits
cfg.line_colors = {[1 .2 .5], [.2 1 .5]}
                    
adam_plot_MVPA(cfg, aHV_left, aHV_right); % pHV_left,  pHV_right, aHV_left, aHV_right
%adam_plot_MVPA(cfg, pCRPS_aff, pCRPS_unaff); %aCRPS_aff, aCRPS_unaff, 

%% 
%% COMPARE THINGGGS
cfg = [];
cfg.mpcompcor_method = 'cluster_based';
comp_stats_a = ...
adam_compare_MVPA_stats(cfg, aHV_right, aHV_left);

comp_stats_p = ...
adam_compare_MVPA_stats(cfg, pHV_right, pHV_left);

comp_left = ...
adam_compare_MVPA_stats(cfg, aHV_left, pHV_left);

comp_right = ...
adam_compare_MVPA_stats(cfg, aHV_right, pHV_right);
 
%% COMPARE THINGGGS
cfg = [];
cfg.mpcompcor_method = 'cluster_based';
comp_a = ...
adam_compare_MVPA_stats(cfg, aCRPS_aff, aCRPS_unaff);

comp_p = ...
adam_compare_MVPA_stats(cfg, pCRPS_aff, pCRPS_unaff);

comp_aff = ...
adam_compare_MVPA_stats(cfg, aCRPS_aff, pCRPS_aff);

comp_unaff = ...
adam_compare_MVPA_stats(cfg, aCRPS_unaff, pCRPS_unaff);

%%
cfg.singleplot = true;
cfg.splinefreq = 65;
cfg.acclim2D = [.4 .85];   % modifies the y-limits
%adam_plot_MVPA(cfg, comp_a, aCRPS_aff, aCRPS_unaff);
%adam_plot_MVPA(cfg, comp_p, pCRPS_aff, pCRPS_unaff);
%adam_plot_MVPA(cfg, comp_aff, aCRPS_aff, pCRPS_aff);
adam_plot_MVPA(cfg, comp_unaff, aCRPS_unaff, pCRPS_unaff);
