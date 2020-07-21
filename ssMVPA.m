
%% ----------------- HEALTHY SUPER-SUBJECT ANALYSIS --------------------- %

% This script runs first level MVPA on the single block consisting of all
% trials perfomed by HV stacked together created in build_supersubject

clear; close all;
%%
% main settings
cfg = [];
cfg.datadir = 'C:\Users\HP\Desktop\M-thesis\Data'; % path to preprocessed data files
cfg.class_method = 'AUC';         % decoding measure 
cfg.nfolds = 10;                  % number of folds for cross-valudation
cfg.resample = 'no';               % downsample data to save up some time, alterantive = 'no'
cfg.model = 'BDM';                % decoding (BDM = Backward Decoding Model) vs forward modeling (FEM = Forward Encoding Model)
cfg.balance_events = 'yes';       % Balance events within stimulus classes (currently always undersamples)
cfg.balance_classes = 'yes';      % Balance classes in the training set: 'yes' (default)
cfg.raw_or_tfr = 'raw';           % Perform decoding on raw data vs perform TFA (alternatively: 'tfr')

cfg.filenames = {'supersubject', 'supersubject_active'};  % list of files to be analyzed
cfg.crossclass = 'no';             % time-by-time temporal generalization (alternative: 'yes') or just the diagonal 
cfg.channels = 'ALL_NOSELECTION'; 

%%
clear class_spec;
class_spec{1} = '1,6';    % thumb ?
class_spec{2} = '5,10';   % little
cfg.class_spec = class_spec;   % specification of stimulus classes

cfg.outputdir = 'C:\Users\HP\Desktop\M-thesis\Results\ss';  % where the output is generated
% first level analysis
adam_MVPA_firstlevel(cfg);

%% EACH FINGER INDIVIDUALLY, TAKES FOREVER BEWARE

% clear class_spec;
% class_spec{1} = '2,7';    % index
% class_spec{2} = '1,6,3,8,4,9,5,10'; % all
% cfg.class_spec = class_spec;   % specification of stimulus classes
% 
% 
% cfg.outputdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\ss\2(INDEX)';  % where the output is generated
% % first level analysis
% adam_MVPA_firstlevel(cfg);
% %%
% clear class_spec;
% class_spec{1} = '3,8';    % middle
% class_spec{2} = '1,6,2,7,4,9,5,10'; % all
% cfg.class_spec = class_spec;   % specification of stimulus classes
% 
% cfg.outputdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\ss\3(MIDDLE)';  % where the output is generated
% % first level analysis
% adam_MVPA_firstlevel(cfg);
% %%
% clear class_spec;
% class_spec{1} = '4,9';    % ring
% class_spec{2} = '1,6,2,7,3,8,5,10'; % all
% cfg.class_spec = class_spec;   % specification of stimulus classes
% 
% cfg.outputdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\ss\4(RING)';  % where the output is generated
% % first level analysis
% adam_MVPA_firstlevel(cfg);
% %%
% clear class_spec;
% class_spec{1} = '5,10';    % little
% class_spec{2} = '1,6,2,7,3,8,4,9'; % all
% cfg.class_spec = class_spec;   % specification of stimulus classes
% 
% cfg.outputdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\ss\5(LITTLE)';  % where the output is generated
% % first level analysis
% adam_MVPA_firstlevel(cfg);

%% ALL VS ALL

clear; close all;

%%
% main settings
cfg = [];
cfg.datadir = 'C:\Users\HP\Desktop\M-thesis\Data'; % path to preprocessed data files
cfg.class_method = 'accuracy';         % decoding measure 
cfg.nfolds = 10;                  % number of folds for cross-valudation
cfg.resample = 'no';               % downsample data to save up some time, alterantive = 'no'
cfg.model = 'BDM';                % decoding (BDM = Backward Decoding Model) vs forward modeling (FEM = Forward Encoding Model)
cfg.balance_events = 'yes';       % Balance events within stimulus classes (currently always undersamples)
cfg.balance_classes = 'yes';      % Balance classes in the training set: 'yes' (default)
cfg.raw_or_tfr = 'raw';           % Perform decoding on raw data vs perform TFA (alternatively: 'tfr')

cfg.filenames = {'supersubject', 'supersubject_active_corr'};  % list of files to be analyzed
cfg.crossclass = 'no';             % time-by-time temporal generalization (alternative: 'yes') or just the diagonal 
cfg.channels = 'ALL_NOSELECTION'; 

%%
clear class_spec;
class_spec{1} = '1,6';    % thumb
class_spec{2} = '2,7';   % little finger ?
class_spec{3} = '3,8';    % medium ?
class_spec{4} = '4,9';    % ring ?
class_spec{5} = '5,10';   % little
cfg.class_spec = class_spec;   % specification of stimulus classes

cfg.outputdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\ss';  % where the output is generated
% first level analysis
adam_MVPA_firstlevel(cfg);

%%
%% ---------------------------- plotting ------------------------------------
%%
cfg.startdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\ss\ss_allvsall'; % results folder
cfg.mpcompcor_method = 'cluster_based';  % for now only one subj so no stats, but 'cluster_based';
cfg.iterations = 1000;      % reduce nr of iterations in the cluster based permutation
%cfg.plotsubjects = true;    % single subject decoding plots
%cfg.singleplot = true;
%cfg.splinefreq = 60;       % Hz low-pass filter cause single subject is hella messy
cfg.trainlim = [-95 500];
cfg.reduce_dims = 'diag'

% thumb = adam_compute_group_MVPA(cfg);  %select the appropriate thing
% index = adam_compute_group_MVPA(cfg);
% middle = adam_compute_group_MVPA(cfg);
% ring = adam_compute_group_MVPA(cfg);
% little = adam_compute_group_MVPA(cfg);

% p_all = adam_compute_group_MVPA(cfg);
% a_all = adam_compute_group_MVPA(cfg);

%%

%adam_savepstructs(cfg, thumb, index, middle, ring, little);

%%
cfg.singleplot = true;
cfg.splinefreq = 130;
cfg.acclim2D = [.19 .27]; 
cfg.timetick = 50;
cfg.line_colors = {[.3 .3 1]}; %{[], [1 .3 .3], [.6 .6 1], [1 0 0], [1 .3 .3], [1 .6 .6]};

adam_plot_MVPA(cfg, p_all); %thumb, index, middle, ring, little);
