
%% ----------------- HEALTHY SUPER-SUBJECT ANALYSIS --------------------- %

% This script runs first level MVPA on the single block consisting of all
% trials perfomed by HV stacked together 

clear; close all;

path_ss_input = '';  % >>> POINT TO THE LOCATION OF SUPER-SUBJECT
path_ss_output = ''; % >>> SET directory to save results. 

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 1 VS. ALL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% main settings
cfg = [];
cfg.datadir = path_ss_input;      % path to preprocessed data files
cfg.class_method = 'AUC';         % decoding measure 
cfg.nfolds = 10;                  % number of folds for cross-valudation
cfg.resample = 'no';              % downsample data to save up some time, 'no'
cfg.model = 'BDM';                % decoding (BDM = Backward Decoding Model) vs forward modeling (FEM = Forward Encoding Model)
cfg.balance_events = 'yes';       % Balance events within stimulus classes (currently always undersamples)
cfg.balance_classes = 'yes';      % Balance classes in the training set: 'yes' (default)
cfg.raw_or_tfr = 'raw';           % Perform decoding on raw data vs perform TFA (alternatively: 'tfr')

cfg.filenames = {'ss_passive', 'ss_active'};  % list of files to be analyzed

cfg.crossclass = 'no';            % time-by-time temporal generalization (alternative: 'yes') or just the diagonal 
cfg.channels = 'ALL_NOSELECTION'; % perform classiciation using all channels

%%
clear class_spec;
class_spec{1} = '1,6';                % thumb 
class_spec{2} = '2,7,3,8,4,9,5,10';   % all (non-thumb)
cfg.class_spec = class_spec;   % specification of stimulus classes

cfg.outputdir = strcat(path_ss_output, '/1(THUMB)');  % where the output is generated
% first level analysis
adam_MVPA_firstlevel(cfg);

%%
clear class_spec;
class_spec{1} = '2,7';                % index
class_spec{2} = '1,6,3,8,4,9,5,10';   % all
cfg.class_spec = class_spec;   % specification of stimulus classes

cfg.outputdir = strcat(path_ss_output, '/2(INDEX)');  % where the output is generated
% first level analysis
adam_MVPA_firstlevel(cfg);

%%
clear class_spec;
class_spec{1} = '3,8';               % middle
class_spec{2} = '1,6,2,7,4,9,5,10';  % all
cfg.class_spec = class_spec;   % specification of stimulus classes
 
cfg.outputdir = strcat(path_ss_output,'/3(MIDDLE)');  % where the output is generated
% first level analysis
adam_MVPA_firstlevel(cfg);

%%
clear class_spec;
class_spec{1} = '4,9';               % ring
class_spec{2} = '1,6,2,7,3,8,5,10';  % all
cfg.class_spec = class_spec;   % specification of stimulus classes
 
cfg.outputdir = strcat(path_ss_output,'/4(RING)');  % where the output is generated
% first level analysis
adam_MVPA_firstlevel(cfg);

%%
clear class_spec;
class_spec{1} = '5,10';             % little
class_spec{2} = '1,6,2,7,3,8,4,9';  % all
cfg.class_spec = class_spec;   % specification of stimulus classes

cfg.outputdir = strcat(path_ss_output,'/5(LITTLE)';  % where the output is generated
% first level analysis
adam_MVPA_firstlevel(cfg);

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ ALL VS. ALL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Re- define main settings (just to be safe)
cfg = [];
cfg.datadir = path_ss_input;      % path to preprocessed data files
cfg.class_method = 'accuracy';    % decoding measure 
cfg.nfolds = 10;                  % number of folds for cross-valudation
cfg.resample = 'no';              % downsample data to save up some time, alterantive = 'no'
cfg.model = 'BDM';                % decoding (BDM = Backward Decoding Model)
cfg.balance_events = 'yes';       % Balance events within stimulus classes (currently always undersamples)
cfg.balance_classes = 'yes';      % Balance classes in the training set: 'yes' (default)
cfg.raw_or_tfr = 'raw';           % Perform decoding on raw data

cfg.filenames = {'ss_passive', 'ss_active'};  % list of files to be analyzed

cfg.crossclass = 'no';            % time-by-time temporal generalization (alternative: 'yes') or just the diagonal 
cfg.channels = 'ALL_NOSELECTION'; 

%%
clear class_spec;
class_spec{1} = '1,6';    % thumb
class_spec{2} = '2,7';    % index
class_spec{3} = '3,8';    % middle
class_spec{4} = '4,9';    % ring
class_spec{5} = '5,10';   % little
cfg.class_spec = class_spec;   % specification of stimulus classes

cfg.outputdir = strcat(path_ss_output, '/ss_allvsall');  % where the output is generated
% first level analysis
adam_MVPA_firstlevel(cfg);

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 1  VS. 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Re- define main settings (just to be safe)
cfg = [];
cfg.datadir = path_ss_input;      % path to preprocessed data files
cfg.class_method = 'AUC';         % decoding measure 
cfg.nfolds = 10;                  % number of folds for cross-valudation
cfg.resample = 'no';              % downsample data to save up some time, alterantive = 'no'
cfg.model = 'BDM';                % decoding (BDM = Backward Decoding Model)
cfg.balance_events = 'yes';       % Balance events within stimulus classes (currently always undersamples)
cfg.balance_classes = 'yes';      % Balance classes in the training set: 'yes' (default)
cfg.raw_or_tfr = 'raw';           % Perform decoding on raw data

cfg.filenames = {'ss_passive', 'ss_active'};  % list of files to be analyzed

cfg.crossclass = 'no';            % time-by-time temporal generalization (alternative: 'yes') or just the diagonal 
cfg.channels = 'ALL_NOSELECTION'; 

%%
clear class_spec;
class_spec{1} = '1,6';    % thumb
class_spec{2} = '5,10';   % little
cfg.class_spec = class_spec;   % specification of stimulus classes

cfg.outputdir = strcat(path_ss_output, '/ss_1vs5');  % where the output is generated
% first level analysis
adam_MVPA_firstlevel(cfg);

%% ------------------------------------------------------------------------
%% -------------------------- Plot results --------------------------------
%% ------------------------------------------------------------------------

cfg.startdir = path_ss_output;     % results folder
cfg.mpcompcor_method = 'none';     % for now only one subj, so no stats
cfg.trainlim = [-99 500];          % select window of interest for training
cfg.reduce_dims = 'diag'

% 1 vs. all 
thumb = adam_compute_group_MVPA(cfg);  %select the appropriate folder
index = adam_compute_group_MVPA(cfg);
middle = adam_compute_group_MVPA(cfg);
ring = adam_compute_group_MVPA(cfg);
little = adam_compute_group_MVPA(cfg);
% all vs. all
p_all = adam_compute_group_MVPA(cfg);
a_all = adam_compute_group_MVPA(cfg);
% 1 vs 5
p_15 = adam_compute_group_MVPA(cfg);
a_15 = adam_compute_group_MVPA(cfg);

%% plotting 

cfg.singleplot = true;
cfg.splinefreq = 130;    % Hz low-pass filter cause single subject is hella messy
cfg.acclim2D = [.19 .27]; % >>> ADJUST TO FIT VALUES
cfg.timetick = 50;
cfg.line_colors = {[.3 .3 1]}; %{[1 .3 .3], [.6 .6 1], [1 0 0], [1 .3 .3], [1 .6 .6]};

adam_plot_MVPA(cfg, thumb, index, middle, ring, little);
% adam_plot_MVPA(cfg, p_all, a_all);
% adam_plot_MVPA(cfg, p_15, a_15);

%% ------------------------------------------------------------------------
%% ------------------------- Compute windows ------------------------------
%% ------------------------------------------------------------------------

% create a new folder if it does not exist and move all 1 vs. all results 
% into one folder
ss_1vsall_dir = strcat(path_ss_output, '/ss_1vsall'); 
if ~exist(ss_1vsall_dir, 'dir')
    mkdir(ss_1vsall_dir);
end

fings = { '1(THUMB)', '2(INDEX)', '3(MIDDLE)', '4(RING)', '5(LITTLE)' }

for i = 1:length(fings)
    copyfile(strcat(path_ss_output,'/', fings{i}, '/ALL_NOSELECTION/CLASS_PERF_ss_passive_10fold.mat'), (strcat(ss_1vsall_dir,'/passive'))
    copyfile(strcat(path_ss_output,'/', fings{i}, '/ALL_NOSELECTION/CLASS_PERF_ss_active_10fold.mat'), (strcat(ss_1vsall_dir,'/active'))
end    

%% run cluster based permutation
cfg.startdir = ss_1vsall_dir;           % results folder
cfg.mpcompcor_method = 'cluster_based'; % permutation with default 1000 iterations
cfg.trainlim = [-99 500];               % select window of interest for training
cfg.reduce_dims = 'diag'

% 1 vs. all 
p1vsall = adam_compute_group_MVPA(cfg);  %select the appropriate folder
a1vsall = adam_compute_group_MVPA(cfg);

%% save significant clusters into a txt file
adam_savepstructs(cfg, p1vsall, a1vsall); 

%% plotting 

cfg.splinefreq = 130;     % Hz low-pass filter cause single subject is hella messy
cfg.acclim2D = [.40 .80]; % >>> ADJUST TO FIT VALUES
cfg.timetick = 50;
cfg.line_colors = {[.3 .3 1] [1 .3 .3]};

adam_plot_MVPA(cfg, p1vsall, a1vsall);

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ THE END :) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
