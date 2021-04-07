% SECOND

% FUNCTION: Extracts channel signal for a specified subject and
% averages across trials. Returns averaged epoch data per subject, per
% trial condition and saves to .mat file.
% -------------------------------------------------------------------------
% Inputs:
%   subj         =   subject code as string e.g. 'hc001'
%   channel      =   channel as string e.g. 'Pz'
%   timeStart    =   start of time window
%   timeEnd      =   end of time window
%   component    =   component code as string e.g. 'P3'
%
% Outputs:
%   data_cond1   =   average of trials for channel for condition 1     
%   data_cond2   =   average of trials for channel for condition 2
% -------------------------------------------------------------------------

function [data_cond1, data_cond2] = getComponent_gen(subj, channel, timeStart, timeEnd, component, data_dir)
% added
% subj = 'hc001';
% channel = 'Pz';
% %0.3, 0.8, 'P3'
% timeStart    = 0.3;
% timeEnd      = 0.8;
% component    = 'P3';
% Time window 300 - 800 ms for P3
% Time window 250 - 350 ms for N2

% Initialise filepaths and load subject epoch data
% -------------------------------------------------------------------------
 %data_dir = "D:\D\Alik\MDD ERP Data";
% folder = sprintf(main + "%s", subj);
folder = data_dir;
cd(data_dir)%cd(folder)
% filename = sprintf('Copy of %s_MSIT_eeg_Onset_ar-epo.fif', subj);%
cd(folder)
subjFile = sprintf('%s_correctEpochs_FT.mat', subj);
load(subjFile);

% Extract time window and average trials by condition
% -------------------------------------------------------------------------

% Average over condition 1 trials
cfg = []; 
cfg.trials = find(correctTrial_csv.Condition == 1);
%cfg.channel = {channel};
cfg.latency = [timeStart timeEnd];

data_cond1 = ft_timelockanalysis(cfg, correctEpochs);


% Average over condition 2 trials
cfg = []; 
cfg.trials = find(correctTrial_csv.Condition == 2);
%cfg.channel = {channel};
cfg.latency = [timeStart timeEnd];

data_cond2 = ft_timelockanalysis(cfg, correctEpochs);

% Save variables to MATLAB workspace .mat
% -------------------------------------------------------------------------
filename_cond1 = sprintf('%s_%s_%s_avgCond1.mat', subj, channel, component);
filename_cond2 = sprintf('%s_%s_%s_avgCond2.mat', subj, channel, component);
save(filename_cond1, 'data_cond1');
save(filename_cond2, 'data_cond2');

end