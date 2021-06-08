 %% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
classdef utility
    methods
        function organize_output(results_path, results={'/p_left' '/p_right' '/a_left' '/a_right'});
            % first divide HV from CRPS patients 
            for i = 1:length(results)
                if i < 3
                    copyfile(strcat(results_path, results{i}, '/ALL_NOSELECTION/CLASS_PERF_P*.mat'), ...
                        (strcat(results_path,'/CRPS/passive/ALL_NOSELECTION'))
                    copyfile(strcat(results_path, results{i}, '/ALL_NOSELECTION/CLASS_PERF_H*.mat'), ...
                        (strcat(results_path,'/HV/passive/ALL_NOSELECTION'))
                else
                    copyfile(strcat(results_path, results{i}, '/ALL_NOSELECTION/CLASS_PERF_P*.mat'), ...
                        (strcat(results_path,'/CRPS/active/ALL_NOSELECTION'))
                    copyfile(strcat(results_path, results{i}, '/ALL_NOSELECTION/CLASS_PERF_H*.mat'), ...
                        (strcat(results_path,'/HV/active/ALL_NOSELECTION'))
                end
            end 

            % then affected from the unaffected side
            % in the passive conditon is easier becasue the filename contains "aff" or "unaff"
            for i = 1:2
                movefile(strcat(results_path, results{i}, '/ALL_NOSELECTION/', '*_unaff_*.mat'), ...
                    (strcat(results_path,'/p_unaff/ALL_NOSELECTION'))
                movefile(strcat(results_path, results{i}, '/ALL_NOSELECTION/', '*_aff_*.mat'), ...
                    (strcat(results_path,'/p_aff/ALL_NOSELECTION'))
            end

            % in the active condition we have to specify what side is unaffected 
            right_aff = {'04', '10', '14', '15') % patients with right affected

            for i = 1:length(right_aff)
                movefile(strcat(results_path,'/a_left/ALL_NOSELECTION/CLASS_PERF_P', right_aff{i}, '*.mat'), ...
                    (strcat(results_path,'/a_unaff/ALL_NOSELECTION'))
                movefile(strcat(results_path,'/a_right/ALL_NOSELECTION/CLASS_PERF_P', right_aff{i}, '*.mat'), ...
                    (strcat(results_path,'/a_aff/ALL_NOSELECTION'))
            end 

            % move the remaining patients to their folder
            movefile(strcat(results_path,'/a_left/ALL_NOSELECTION/CLASS_PERF_P', '*.mat'), ...
                (strcat(results_path,'/a_aff/ALL_NOSELECTION'))
            movefile(strcat(results_path,'/a_right/ALL_NOSELECTION/CLASS_PERF_P', '*.mat'), ...
                (strcat(results_path,'/a_unaff/ALL_NOSELECTION'))
        end
        function correct_classes(dataset, pathtoresults);
        % Stimulus type field needs to contain information about the finger that is being stimulated
        % Current .set files only have 'STIM' or 'RESP' to indicate the type of
        % event but we want to use finger ids as ADAM classes. 
        % The information about the stimulated finger is extracted from event.codes
        % and 'STIM' values for event.type and for epoch.enettype are subtitued with 
        % finger ids. Note: they both need to be strings for ADAM to use them as classes.

            for subj = 1:length(dataset)
                % file name
                fname = strcat(dataset{subj},'.set');

                % start EEGLAB
                [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

                % load curret dataset
                EEG = pop_loadset('filename', fname, 'filepath', PATHTORAW);
                [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
                EEG = eeg_checkset( EEG );

                % optional: check number of events per subject
                % disp(length(EEG.event))

                % Change event.type values
                for i = 1:length(EEG.event) % loop through all events 
                    if EEG.event(i).type == 'STIM';
                       f = EEG.event(i).codes{2,2}; % copy and store finger info into f
                       EEG.event(i).type = cond_string(f);
                       ALLEEG.event(i).type = cond_string(f);
                    end
                end

                % Change epoch.eventtype values
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
                EEG = pop_saveset( EEG, 'filename', dataset{subj},'filepath', pathtoresults); 
            end
        end
    end
end