%% ----------- ALL vs ALL TEMPORAL GENERALIZATION ANALYSIS -------------- %

% This script runs first (individual subject) and second (group) level TGA on 
% passive and active finger stimulation. This strategie (all vs. all) uses a 
% multiclass decoder to tell all fingers from each other. For details of the 
% decoding stratergy see Defina et al (2021).

% Exp1 = active conditon (120 trials for finger 1 and 5, 80 in total for 2 3 and 4).
% Exp2 = passive condition (100 trials for each finger) 

% see Kuttikat et al. (2018) or Defina et al. (2021) for details on experimental
% design and ADAM toolbox tutorials for information about the parameters. 

clear; close all;  % clear workspace and close any figures

path_active_correct = '';  % >>> POINT TO THE LOCATION OF corrected active files
        % >>> ATTENTION: active files can be changed to the NO ERROR trials or 
        % the NO EARLY trials corrected files that were created in script 2 and 3.
        % Remember to change the output directory too, not overwrite files.
path_passive_correct = ''; % >>> POINT TO THE LOCATION OF corrected passive files

path_TGA_output = ''; % >>> SET directory to save results. 

% call utility script where some functions are defined
func = utility.m;

%% 
active_filenames = { 'H07_Exp1_left' 'H07_Exp1_right' ... 
                     'H08_Exp1_left' 'H08_Exp1_right' ...
                     'H10_Exp1_left' 'H10_Exp1_right' ...
                     'H11_Exp1_left' 'H11_Exp1_right' ...
                     'H14_Exp1_left' 'H14_Exp1_right' ...
                     'H16_Exp1_left' 'H16_Exp1_right' ...
                     'H17_Exp1_left' 'H17_Exp1_right' ...
                     'H19_Exp1_left' 'H19_Exp1_right' ...
                     'H20_Exp1_left' 'H20_Exp1_right' ... 
                     'H22_Exp1_left' 'H22_Exp1_right' ...
                     'H23_Exp1_left' 'H23_Exp1_right' ...
                     'H25_Exp1_left' 'H25_Exp1_right' ...
                     'P04_Exp1_left' 'P04_Exp1_right' ...
                     'P07_Exp1_left' 'P07_Exp1_right' ...
                     'P08_Exp1_left' 'P08_Exp1_right' ...
                     'P10_Exp1_left' 'P10_Exp1_right' ...
                     'P12_Exp1_left' 'P12_Exp1_right' ...
                     'P13_Exp1_left' 'P13_Exp1_right' ...
                     'P14_Exp1_left' 'P14_Exp1_right' ...
                     'P15_Exp1_left' 'P15_Exp1_right' ...
                     'P16_Exp1_left' 'P16_Exp1_right' ...
                     'P17_Exp1_left' 'P17_Exp1_right' ...
                     'P18_Exp1_left' 'P18_Exp1_right' ...
                     'P19_Exp1_left' 'P19_Exp1_right' ...
                     'P20_Exp1_left' 'P20_Exp1_right' };

passive_filenames = { 'H07_Exp2_left' 'H07_Exp2_right' ... 
                     'H08_Exp2_left' 'H08_Exp2_right' ...
                     'H10_Exp2_left' 'H10_Exp2_right' ...
                     'H11_Exp2_left' 'H11_Exp2_right' ...
                     'H14_Exp2_left' 'H14_Exp2_right' ...
                     'H16_Exp2_left' 'H16_Exp2_right' ...
                     'H17_Exp2_left' 'H17_Exp2_right' ...
                     'H19_Exp2_left' 'H19_Exp2_right' ...
                     'H20_Exp2_left' 'H20_Exp2_right' ...
                     'H21_Exp2_left' 'H21_Exp2_right' ...
                     'H22_Exp2_left' 'H22_Exp2_right' ...
                     'H23_Exp2_left' 'H23_Exp2_right' ...
                     'H25_Exp2_left' 'H25_Exp2_right' ...
                     'P04_Exp2_left_unaff' 'P04_Exp2_right_aff' ...
                     'P07_Exp2_left_aff'   'P07_Exp2_right_unaff' ...
                     'P08_Exp2_left_aff'   'P08_Exp2_right_unaff' ...
                     'P10_Exp2_left_unaff' 'P10_Exp2_right_aff' ...
                     'P12_Exp2_left_aff'   'P12_Exp2_right_unaff' ...
                     'P13_Exp2_left_aff'   'P13_Exp2_right_unaff' ...
                     'P14_Exp2_left_unaff' 'P14_Exp2_right_aff' ...
                     'P15_Exp2_left_unaff' 'P15_Exp2_right_aff' ...
                     'P16_Exp2_left_aff'   'P16_Exp2_right_unaff' ...
                     'P17_Exp2_left_aff'   'P17_Exp2_right_unaff' ...
                     'P18_Exp2_left_aff'   'P18_Exp2_right_unaff' ...
                     'P19_Exp2_left_aff'   'P19_Exp2_right_unaff' ...
                     'P20_Exp2_left_aff'   'P20_Exp2_right_unaff'};
                 
left_active = file_list_restrict(active_filenames,'left');    % only the left stimulation blocks
right_active = file_list_restrict(active_filenames,'right');  % only the right stimulation blocks
left_passive = file_list_restrict(passive_filenames,'left');    % only the left stimulation blocks
right_passive = file_list_restrict(passive_filenames,'right');  % only the right stimulation blocks

%% main settings
cfg = [];
cfg.class_method = 'accuracy';     % decoding measure 
cfg.nfolds = 10;               % number of folds for cross-valudation
cfg.resample = 'no';           % downsample data to save up some time 
cfg.model = 'BDM';             % decoding (BDM = Backward Decoding Model)
cfg.balance_events = 'yes';    % Balance events within stimulus classes
cfg.balance_classes = 'yes';   % Balance classes in the training set
cfg.raw_or_tfr = 'raw';        % Perform decoding on raw data
cfg.crossclass = 'yes';        % time-by-time cross-classification

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ LEFT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
clear class_spec;
class_spec{1} = '1';   % thumb 
class_spec{2} = '2';   % index 
class_spec{3} = '3';   % medium 
class_spec{4} = '4';   % ring 
class_spec{5} = '5';   % little finger 
cfg.class_spec = class_spec;  % specification of stimulus classes

% ACTIVE 
cfg.datadir = path_active_correct  % path to preprocessed data files
cfg.filenames = left_active;  % list of files to be analyzed
cfg.outputdir = strcat(path_TGA_output, '/a_left');  % where the output is generated
cfg.crossclass = 'yes';            % time-by-time temporal generalization 
cfg.channels = 'ALL_NOSELECTION';  % for feature selection

% first level analysis
adam_MVPA_firstlevel(cfg);

% PASSIVE
cfg.datadir = path_passive_correct  % path to preprocessed data files
cfg.filenames = left_passive;  % list of files to be analyzed
cfg.outputdir = strcat(path_TGA_output, '/p_left');  % where the output is generated
cfg.crossclass = 'yes';            % time-by-time temporal generalization 
cfg.channels = 'ALL_NOSELECTION';  % for feature selection

% first level analysis
adam_MVPA_firstlevel(cfg);

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ RIGHT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
clear class_spec;
class_spec{1} = '6';    % thumb 
class_spec{2} = '7';    % index 
class_spec{3} = '8';    % medium
class_spec{4} = '9';    % ring 
class_spec{5} = '10';   % little finger 
cfg.class_spec = class_spec;   % specification of stimulus classes

% ACTIVE 
cfg.datadir = path_active_correct  % path to preprocessed data files
cfg.filenames = right_active;  % list of files to be analyzed
cfg.outputdir = strcat(path_TGA_output, '/a_right'); % where the output is generated
cfg.crossclass = 'yes';            % time-by-time temporal generalization
cfg.channels = 'ALL_NOSELECTION';  % for feature selection

% first level analysis
adam_MVPA_firstlevel(cfg);

% PASSIVE
cfg.datadir = path_passive_correct  % path to preprocessed data files
cfg.filenames = right_passive;  % list of files to be analyzed
cfg.outputdir = strcat(path_TGA_output, '/p_right');  % where the output is generated
cfg.crossclass = 'yes';            % time-by-time temporal generalization 
cfg.channels = 'ALL_NOSELECTION';  % for feature selection

% first level analysis
adam_MVPA_firstlevel(cfg);

%% ------------------------------------------------------------------------
%% ----------- GROUP DECODING (CLUSTER-BASED PERMUTATION) -----------------
%% ------------------------------------------------------------------------

% This section runs the second level (group) analysis based on the first level 
% results we just obstined. The script can be easily costumed with respect to 
% the comparisons of interest.

% Results folder needs to be organized so that each group (condition or side)
% - has a "ALL_NOSELCTION" folder nested within containig all the individual 
% - data belonging to the gorup. That is if no channel selection was adopted.

% Let's reorganize the results according to the comparisons of interest
% create a new folder if it does not exist and move all 1 vs. all results 
% into one folder

func.organize_output(path_TGA_output)

%% main settings

cfg.startdir = path_TGA_output;      % 1st lvl results folder
cfg.mpcompcor_method = 'none';       % no test for significance
cfg.iterations = 1000;               % nr of iterations in the cluster based permutation
%cfg.plotsubjects = true;            % single subject decoding plots to check for quality
%cfg.splinefreq = 40;                % Hz low-pass filter cause single subject is hella messy
cfg.trainlim = [-100 500];           % specify a ms interval in the training data

% costume the variables according to the comparisons of interest

a_left = adam_compute_group_MVPA(cfg);  %select the appropriate folder
a_right = adam_compute_group_MVPA(cfg);
a_aff = adam_compute_group_MVPA(cfg);  %select the appropriate folder
a_unaff = adam_compute_group_MVPA(cfg);

p_left = adam_compute_group_MVPA(cfg);  %select the appropriate folder
p_right = adam_compute_group_MVPA(cfg);
p_aff = adam_compute_group_MVPA(cfg);  %select the appropriate folder
p_unaff = adam_compute_group_MVPA(cfg);

aHV = adam_compute_group_MVPA(cfg);
pHV = adam_compute_group_MVPA(cfg);
aCRPS = adam_compute_group_MVPA(cfg);
pCRPS = adam_compute_group_MVPA(cfg);

%% saving the statistics into a txt file
adam_savepstructs(cfg, aHV, aCRPS, a_left, a_right, a_aff, a_unaff); 
adam_savepstructs(cfg, pHV, pCRPS, p_left, p_right, p_aff, p_unaff); 

%% plotting

cfg.singleplot = true;     % if you want to plot more than one group result together
cfg.timetick = 100;        % changes time tickmarks to 100 ms.
cfg.splinefreq = 80;       % smooths the timecourse, only for presentation
cfg.acclim2D = [.16 .32];  % modifies the range of accuracy values

%cfg.line_colors = {[.3 .8 .3], [.3 .3 1]}; % light blue and green
%cfg.line_colors = {[.9 .8 .3], [.8 0 0]}; % yeloow-ish and dark red                 

% plotting
adam_plot_MVPA(cfg, pCRPS, pHV); % group comparison passive codition 
adam_plot_MVPA(cfg, p_left, p_right); % HV passive condition 
adam_plot_MVPA(cfg, p_aff, p_unaff); % CRPS passive condition 

adam_plot_MVPA(cfg, aCRPS, aHV); % group comparison active codition 
adam_plot_MVPA(cfg, a_left, a_right); % HV active condition 
adam_plot_MVPA(cfg, a_aff, a_unaff); % CRPS active condition 


%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ THE END :) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

