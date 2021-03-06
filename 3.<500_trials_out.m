
clear; close all;  % clear workspace and close any figures

PATHTORAW = '';                  % >>> POINT TO THE LOCATION OF RAW DATA
path_active_correct_no500 = '';  % >>> SET PATH for saving corrected active files without early response trials

%% active filenames

active_filenames = {
                 'H07_Exp1_left' 'H07_Exp1_right' ... 
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
                 'P20_Exp1_left' 'P20_Exp1_right' ...
                }';

%%
count_trials = []; 

for subj = 1:length(active_filenames)
    % file name
    fname = strcat(active_filenames{subj},'.set');
    
    % start EEGLAB
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    % load curret dataset
    EEG = pop_loadset('filename', fname,'filepath', PATHTORAW);
    
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    
    rm_list = [];
    
     for i = 1:length(EEG.event) % loop through all events 
        if EEG.event(i).type == 'STIM';
           f = EEG.event(i).codes{2,2}; % where the finger info is stored
           EEG.event(i).type = cond_string(f);
           ALLEEG.event(i).type = cond_string(f);
        end
    end
    
    for ep = 1:length(EEG.epoch)
        if numel(EEG.epoch(ep).eventlatency) == 1 & EEG.epoch(ep).eventtype{1} == 'STIM'
           fing = EEG.epoch(ep).eventcodes{1,1}{2,2};
           EEG.epoch(ep).eventtype = cond_string(fing);
           ALLEEG.epoch(ep).eventtype = cond_string(fing); 
        elseif EEG.epoch(ep).eventtype{1,1} == 'STIM' & EEG.epoch(ep).eventlatency{1,2} < 500
           rm_list = [rm_list; ep];
        elseif EEG.epoch(ep).eventtype{1,1} == 'STIM'
           fing = EEG.epoch(ep).eventcodes{1,1}{2,2};
           EEG.epoch(ep).eventtype = cond_string(fing);
           ALLEEG.epoch(ep).eventtype = cond_string(fing); 
        elseif EEG.epoch(ep).eventtype{1,2} == 'STIM';
           fing = EEG.epoch(ep).eventcodes{1,2}{2,2};
           EEG.epoch(ep).eventtype = cond_string(fing);
           ALLEEG.epoch(ep).eventtype = cond_string(fing);    
        end
    end
    
    EEG = eeg_checkset( EEG );
    count_trials = [count_trials; length(rm_list)];
    
    EEG = pop_select( EEG, 'notrial', rm_list);      
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename', active_filenames{subj},'filepath', path_active_correct_no500);
   
end   

%%
