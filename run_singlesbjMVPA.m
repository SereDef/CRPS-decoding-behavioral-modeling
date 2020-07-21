%%                     SINGLE SUBJECT DECODING

% This script is desidegned to run first level (individual subject) MVPA
% on CRPS (P...) vs HV (H...) finger stimulation data. Both diagonal and
% the full temporal generalization matrix can be obtained. The latter takes
% forever though so heads up (downsampling might be a good idea). 

% Exp1 = active conditon (120 trials for finger 1 and 5, 80 in total for 2 3 and 4).
% Exp2 = passive condition (100 trials for each finger) 

% see Kuttikat et al. (2018) or Defina et al. (hopefully) for details on
% experimental design and ADAM toolbox tutorials for information about the parameters. 

%% (ALL VS ALL) ANALYSIS
% for details of the decoding stratergy see Defina et al (2021?).
% Essentially, it's a multiclass decoder that tells all fingers from each other. 

% For *1 vs 5* approach just modofy the class_spec and the performance measure
% accordingly (I used AUC for two classes, accuracy for multiple classes)

%% 
clear; close all;  % clear workspace and close any figures

%% ---------------------- PASSIVE CONDITION ---------------------------- %%

passive_filenames = { % replace with relevant file names
                 'H07_Exp2_left' 'H07_Exp2_right' ... 
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
                 'P20_Exp2_left_aff'   'P20_Exp2_right_unaff'}';

left_passive = file_list_restrict(passive_filenames,'left');  % only the left stimulation blocks
right_passive = file_list_restrict(passive_filenames,'right');  % only the right stimulation blocks

%CRPS_passive = file_list_restrict(passive_filenames,'P');  % only patients (passive) files
%HV_passive = file_list_restrict(passive_filenames,'H');  % only healthy controls (passive) files

%% main settings
cfg = [];                    % clean the cfg variable just in case
cfg.datadir = 'C:\Users\HP\Desktop\M-thesis\Data\pCorr'; % path to preprocessed data files
cfg.class_method = 'AUC';    % decoding measure of preference, alternative : 'accuracy' 
cfg.nfolds = 10;             % number of folds for cross-validation
cfg.resample = 'no';         % downsample data to save up some time, especially for TGA
cfg.model = 'BDM';           % decoding (BDM = Backward Decoding Model) vs FEM = Forward Encoding Model
cfg.balance_events = 'yes';  % undersamples events for balancing within stimulus classes
cfg.balance_classes = 'yes'; % balances between classes in the training set
cfg.raw_or_tfr = 'raw';      % Perform decoding on raw data(alternatively: 'tfr')

%% PASSIVE - LEFT

clear class_spec;
class_spec{1} = '1';   % thumb 
class_spec{2} = '2';   % index 
class_spec{3} = '3';   % medium 
class_spec{4} = '4';   % ring 
class_spec{5} = '5';   % little finger 
cfg.class_spec = class_spec;   % specification of stimulus classes

cfg.filenames = left_passive;  % list of files to be analyzed
cfg.outputdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\TGM\left_passive';  % where the output is generated
cfg.crossclass = 'yes';            % time-by-time temporal generalization , "no" for just diagonal
cfg.channels = 'ALL_NOSELECTION';  % for feature selection: manually in EEG files prior to analyses 
                                   % OR use cfg.channelpool() and specify channels directly. If not 
                                   % standard 10-20 64-channel layout need to modify select_channels.m 

% first level analysis
adam_MVPA_firstlevel(cfg);

%% PASSIVE - RIGHT

clear class_spec;
class_spec{1} = '6';    % thumb 
class_spec{2} = '7';    % index 
class_spec{3} = '8';    % medium 
class_spec{4} = '9';    % ring 
class_spec{5} = '10';   % little finger 
cfg.class_spec = class_spec;   % specification of stimulus classes

cfg.filenames = right_passive;  % list of files to be analyzed
cfg.outputdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\TGM\right_passive';  % where the output is generated
cfg.crossclass = 'yes';            % time-by-time temporal generalization  
cfg.channels = 'ALL_NOSELECTION';  % no feature selection

% first level analysis
adam_MVPA_firstlevel(cfg);

%%
clear; close all;  % clear workspace and close any figures

%% ----------------------- ACTIVE CONDITION ----------------------------%%

active_filenames = { % replace with relevant file names
                 'H07_Exp1_left' 'H07_Exp1_right' ... 
                 'H08_Exp1_left' 'H08_Exp1_right' ...
                 'H10_Exp1_left' 'H10_Exp1_right' ...
                 'H11_Exp1_left' 'H11_Exp1_right' ...
                 'H14_Exp1_left' 'H14_Exp1_right' ...
                 'H16_Exp1_left' 'H16_Exp1_right' ...
                 'H17_Exp1_left' 'H17_Exp1_right' ...
                 'H19_Exp1_left' 'H19_Exp1_right' ...
                 'H20_Exp1_left' 'H20_Exp1_right' ...
                 'H21_Exp1_left' 'H21_Exp1_right' ...
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
            
left_active = file_list_restrict(active_filenames,'left');    % only the left stimulation blocks
right_active = file_list_restrict(active_filenames,'right');  % only the right stimulation blocks

%CRPS_active = file_list_restrict(active_filenames,'P');  % only patients active
%HV_active = file_list_restrict(active_filenames,'H');    % only healthy controls active

%% main settings
cfg = [];
cfg.datadir = 'C:\Users\HP\Desktop\M-thesis\Data\aCorr'; % path to preprocessed data files
cfg.class_method = 'AUC';      % decoding measure 
cfg.nfolds = 10;               % number of folds for cross-valudation
cfg.resample = 'no';           % downsample data to save up some time 
cfg.model = 'BDM';             % decoding (BDM = Backward Decoding Model)
cfg.balance_events = 'yes';    % Balance events within stimulus classes
cfg.balance_classes = 'yes';   % Balance classes in the training set
cfg.raw_or_tfr = 'raw';        % Perform decoding on raw data

%% ACTIVE - LEFT

clear class_spec;
class_spec{1} = '1';   % thumb 
class_spec{2} = '2';   % index 
class_spec{3} = '3';   % medium 
class_spec{4} = '4';   % ring 
class_spec{5} = '5';   % little finger 
cfg.class_spec = class_spec;  % specification of stimulus classes

cfg.filenames = left_active;  % list of files to be analyzed
cfg.outputdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\TGM\left_active';  % where the output is generated
cfg.crossclass = 'yes';            % time-by-time temporal generalization 
cfg.channels = 'ALL_NOSELECTION';  % for feature selection

% first level analysis
adam_MVPA_firstlevel(cfg);

%% ACTIVE - RIGHT 

clear class_spec;
class_spec{1} = '6';    % thumb 
class_spec{2} = '7';    % index 
class_spec{3} = '8';    % medium
class_spec{4} = '9';    % ring 
class_spec{5} = '10';   % little finger 
cfg.class_spec = class_spec;   % specification of stimulus classes

cfg.filenames = right_active;  % list of files to be analyzed
cfg.outputdir = 'C:\Users\HP\Desktop\M-thesis\Data\Results\TGM\right_active';  % where the output is generated
cfg.crossclass = 'yes';            % time-by-time temporal generalization
cfg.channels = 'ALL_NOSELECTION';  % for feature selection

% first level analysis
adam_MVPA_firstlevel(cfg);

%%
%% THE END :)


