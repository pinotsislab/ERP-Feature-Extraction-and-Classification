% FIRST

% FUNCTION: Extracts only the correctly responded to epochs from the .FIF
% file and corresponding array from the CSV file, and save as a MATLAB 
% workspace.
% -------------------------------------------------------------------------
% Inputs:
%   subj             =     subject code as string e.g. 'hc001'
%
% Outputs:
%   correctTrial_csv =     Table format of CSV files containing only 
%                          correctly responded to trials
%   correctEpochs    =     FieldTrip format data structure consisting of 
%                          only correctly responded to trials
% -------------------------------------------------------------------------
% subj = {'hc001','hc003','hc004','hc006','hc007','hc008','hc009','hc010','hc011'...
%     ...,'hc012','hc014','hc015','hc016','hc017','hc018','hc019','hc020','hc021','hc022','hc023',
%     ...,'hc024','hc025','hc026','hc027','hc028','hc029','hc031','hc033','hc035','hc036',
%     ...,'hc037','hc042','hc044','hc045','pp001','pp002','pp003','pp004','pp005','pp006','pp007','pp008',
%     ...,'pp009','pp010','pp011','pp012','pp013','pp014','pp015','pp016'};
function [correctEpochs, correctTrial_csv] = getCorrectEpochs_dp(subj, dir)

% Initialise filepath and datafile
% -------------------------------------------------------------------------
%example:
% subj = 'hc001';
%
main = "\MDD ERP Data";
%folder = sprintf(main + "%s");%folder = sprintf(main + "%s", subj);
folder = main;
% cd(main)%cd(folder)
cd (dir)

filename = sprintf('Copy of %s_MSIT_eeg_Onset_ar-epo.fif', char(subj));%sprintf('%s_MSIT_eeg_Onset_ar-epo.fif', subj);

% Read FIF data file - extract information
header = ft_read_header(filename);

% Extract trial data from FIF file
cfg = [];
cfg.datafile = filename;
data = ft_preprocessing(cfg);

% Import CSV data file
csvName = sprintf('Copy of %s_msit_1.csv', char(subj));
csvFullFile = fullfile(folder, csvName);
subj_csv = readtable(csvFullFile);

% Remove all irrelevant stimuli to re-index CSV file
stim = subj_csv.Stimuli;
stim_idx = find(~contains(stim, '+'));
subj_csv2 = subj_csv(stim_idx,:);

% Obtain events from epoched file and match with trial data in CSV
events = header.orig.epochs.events;
event_idx = events(:,3) + 1; % Event indices from epoched file
epoch_csv = subj_csv2(event_idx,:); % Trial information corresponding to epoched file

% Obtain event indices from FIF file and match with trial data in CSV file
responseAccuracy = epoch_csv.ResponseAccuracy;
correctTrial_idx = find(responseAccuracy == 1);
correctTrial_csv = epoch_csv(correctTrial_idx,:);

% Select only correctly responded to trials from the epoched data
cfg = [];
cfg.trials = correctTrial_idx;
correctEpochs = ft_preprocessing(cfg, data);

% Save variables as MATLAB workspace
saveName = sprintf('%s_correctEpochs_FT.mat', char(subj));
save(saveName, 'correctEpochs', 'correctTrial_csv');

fprintf('Saved workspace for %s', char(subj))

end