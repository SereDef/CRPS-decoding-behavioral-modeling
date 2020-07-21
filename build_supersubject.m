%% CORRECT IMBALANCES AND ERRORS IN THE CLASS LABELS

clear; close all;  % clear workspace and close any figures

%% FILES
active_filenames = {       
                };
passive_filenames = {
                }';
            
%% stimulus type field needs to contain information about the finger that is being stimulated 

for subj = 1:length(active_filenames)
    % file name
    fname = strcat(active_filenames{subj},'.set');
    
    % start EEGLAB
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    % load curret dataset
    EEG = pop_loadset('filename', fname,'filepath','C:\\pathtooldfiles'); % change to correct location
    
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    disp(length(EEG.event))
    for i = 1:length(EEG.event) % loop through all events 
        if EEG.event(i).type == 'STIM';
           f = EEG.event(i).codes{2,2}; % where the finger info is stored
           EEG.event(i).type = cond_string(f);
           ALLEEG.event(i).type = cond_string(f);
        end
    end
    
    % info needto to be into epoch for ADAM to work
    for ep = 1:length(EEG.epoch)
        if EEG.epoch(ep).eventtype{1} == 'STIM';
           fing = EEG.epoch(ep).eventcodes{1,1}{2,2};
           EEG.epoch(ep).eventtype = cond_string(fing);
           ALLEEG.epoch(ep).eventtype = cond_string(fing);
        elseif EEG.epoch(ep).eventtype{1,2} == 'STIM';
           fing = EEG.epoch(ep).eventcodes{1,2}{2,2};
           EEG.epoch(ep).eventtype = cond_string(fing);
           ALLEEG.epoch(ep).eventtype = cond_string(fing);
        else
          disp('ERROR AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
        end
    end
    
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',active_filenames{subj},'filepath','C:\\path to corrected files'); % ->CHANGE
end

% REPEAT FOR PASSIVE SET

%% create separate datasets with trials belonging to each finger - SUPER SUBJECT

for subj = 1:length(active_filenames)
   for s = 1:5
       name = sprintf('%s_%d',active_filenames{subj},s);
       EEG = pop_selectevent( EEG, 'type',s,'deleteevents','on','deleteepochs','on','invertepochs','off');
       [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, s,'setname',name,'gui','off', 'savenew',name); 
       EEG = eeg_checkset( EEG );
       % go back to the original dataset
       [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, s+1,'retrieve',1,'study',0); 
       EEG = eeg_checkset( EEG );
   end
end

% REPEAT FOR PASSIVE SET

%% CORRECTING FOR NR OF TRIALS IN EACH CLASS (5 AND 1) 

A = {EEG.event(:).type}
edges = unique(A)  %,'stable')
counts = histc(str2num(A(:)), edges(:-1))

%% ------------------------------------------------

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','supersubject_active.set','filepath',''); % change
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );

EEG = pop_selectevent( EEG, 'type',[1 6] ,'deleteevents','on','deleteepochs','on','invertepochs','off');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','16','gui','off'); 
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 
EEG = eeg_checkset( EEG );

EEG = pop_selectevent( EEG, 'type',[10 5] ,'deleteevents','on','deleteepochs','on','invertepochs','off');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','510','gui','off'); 
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',2,'study',0); 
EEG = eeg_checkset( EEG );

EEG = pop_selectevent( EEG, 'type',[2:4 7 8:9] ,'deleteevents','on','deleteepochs','on','invertepochs','off');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','supersubject_sel','gui','off'); 
EEG = eeg_checkset( EEG );

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 6,'retrieve',6,'study',0); 
EEG = eeg_checkset( EEG );

EEG = pop_mergeset( ALLEEG, [4  5  6], 0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 6,'setname','ss_active_corr','savenew','C:\\pathtonewfile','gui','off'); 

eeglab redraw;

