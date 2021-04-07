%% Introduction
%%% 3 steps for ERP analysis. 

%% Prepare global variables

% list of subj numberrs to loop through
subj = {'hc001','hc003','hc004','hc006','hc007','hc008','hc009','hc010','hc011','hc012','hc014','hc015','hc016','hc017','hc018','hc019','hc020','hc021','hc022','hc023','hc024','hc025','hc026','hc027','hc028','hc029','hc031','hc033','hc035','hc036', 'hc037','hc042','hc044','hc045','pp001','pp002','pp003','pp004','pp005','pp006','pp007','pp008','pp009','pp010','pp011','pp013','pp014','pp015','pp016'};
%%% 'pp012' is missing from the correct epochs

% add fieldtrip to the path
% addpath C:\Users\fitzg\Documents\MATLAB\fieldtrip-20201009\fieldtrip-20201003
addpath("C:\Program Files\MATLAB\R2020b\toolbox\fieldtrip-20201214")
ft_defaults

%% 1 Run to correct the Epochs (This was not run, data was supplied from Dimitris via google drive

for i = 1:length(subj)
    [correctEpochs, correctTrial_csv] = getCorrectEpochs_dp(subj{i}, "C:\Users\fitzg\Documents\MATLAB\EEG_data_Depression_Classification\MDD ERP Data");
end

%% Prepare for Component Extraction
correct_epoch_dir = "C:\Users\New Owner\Documents\MATLAB\MDD classification ERP\correct epochs";

% Channels for consideration --  From Dimitris' email

% all_possible_channels =  {'STI001' 'STI002' 'STI003' 'STI004' 'STI005' 'STI006' 'STI007' 'STI008' 'Fp1' 'Fpz' 'Fp2' 'AF7' 'AF3' 'AFz' 'AF4' 'AF8' 'F7' 'F5' 'F3' 'F1' 'Fz' 'F2' 'F4' 'F6' 'F8' 'FT9' 'FT7' 'FC5' 'FC3' 'FC1' 'FCz' 'FC2' 'FC4' 'FC6' 'FT8' 'FT10' 'T9' 'T7' 'C5' 'C3' 'C1' 'Cz' 'C2' 'C4' 'C6' 'T8' 'T10' 'TP9' 'TP7' 'CP5' 'CP3' 'CP1' 'CPz' 'CP2' 'CP4' 'CP6' 'TP8' 'TP10' 'P9' 'P7' 'P5' 'P3' 'P1' 'Pz' 'P2' 'P4' 'P6' 'P8' 'HEOG' 'VEOG' 'ECG' 'P10' 'PO7' 'PO3' 'P0z' 'PO4' 'PO8' 'O1' 'Oz' 'O2' 'Iz' 'STI101' 'STI201' 'STI301' };
all_possible_channels =  {'Fp1' 'Fpz' 'Fp2' 'AF7' 'AF3' 'AFz' 'AF4' 'AF8' 'F7' 'F5' 'F3' 'F1' 'Fz' 'F2' 'F4' 'F6' 'F8' 'FT9' 'FT7' 'FC5' 'FC3' 'FC1' 'FCz' 'FC2' 'FC4' 'FC6' 'FT8' 'FT10' 'T9' 'T7' 'C5' 'C3' 'C1' 'Cz' 'C2' 'C4' 'C6' 'T8' 'T10' 'TP9' 'TP7' 'CP5' 'CP3' 'CP1' 'CPz' 'CP2' 'CP4' 'CP6' 'TP8' 'TP10' 'P9' 'P7' 'P5' 'P3' 'P1' 'Pz' 'P2' 'P4' 'P6' 'P8' 'HEOG' 'VEOG' 'ECG' 'P10' 'PO7' 'PO3' 'P0z' 'PO4' 'PO8' 'O1' 'Oz' 'O2' 'Iz'};

%most_common_channels = {'Fp1' 'Fpz' 'Fp2' 'AF7' 'AF3' 'AFz' 'AF4' 'AF8' 'F7' 'F5' 'F3' 'F1' 'Fz' 'F2' 'F4' 'F6' 'F8' 'FT9' 'FT7' 'FC5' 'FC3' 'FC1' 'FCz' 'FC2' 'FC4' 'FC6' 'FT8' 'FT10' 'T9' 'T7' 'C5' 'C3' 'C1' 'Cz' 'C2' 'C4' 'C6' 'T8' 'T10' 'TP9' 'TP7' 'CP5' 'CP3' 'CP1' 'CPz' 'CP2' 'CP4' 'CP6' 'TP8' 'TP10' 'P9' 'P7' 'P5' 'P3' 'P1' 'Pz' 'P2' 'P4' 'P6' 'P8'};
% missing_Channels = all_possible_channels(ismember(all_possible_channels, most_common_channels) == 0);


% Component = signal direction (Positive P or Negative N) + time of
% interest in ms post-event
% -  Time window 300 - 800 ms for P3
% -  Time window 250 - 350 ms for N2
% -  Time window 0 - 500 ms for full ERP signal visualization
component = 'earlyERP';


switch component
    case 'N2'
        timeStart    = 0.25;
        timeEnd      = 0.35;
    case 'P3'
        timeStart    = 0.3;
        timeEnd      = 0.8;
    case 'fullERP'
        timeStart    = 0.0;
        timeEnd      = 5.0;
    case 'earlyERP'
        timeStart    = 0.0;
        timeEnd      = 0.35;
    otherwise
        print('error, component does not match or is unknown')
end


%% 2 Main loop for Component Extraction -- takes ~ 3.5 hours
%%% This is a trivially parallel problem. Needs to be spread across
%%% multiple threads

for c = 1:length(all_possible_channels)
    for i = 1:length(subj)   
        
      avg_cond1{, data_cond2 = getComponent_gen(subj{i}, all_possible_channels{c}, timeStart, timeEnd, component, correct_epoch_dir);
              
    end
end

grandavg_con  = ft_timelockgrandaverage(cfg, timelock{:,1});
%% 3 Collect metrics from each component
%%% Mean Peak, Peak Latency, Peak Amplitude

header = {'SubjID', 'Channel', 'Component', 'PeakAmp_Cond1', 'PeakAmp_Cond2', 'MeanAmp_Cond1', 'MeanAmp_Cond2', 'Latency_Cond1', 'Latency_Cond2'};

results_total = table();

for c = 1:length(missing_Channels)
    sprintf('Running iteration %s. Channel value is %s', c, missing_Channels{c})
    for i = 1:length(subj)   
      sprintf('Running subject number %s. Subj_ID is %s', i, subj{i})

      results = get_Amplitude_Latency(subj{i}, missing_Channels{c}, 'N2');
      results_total = [results_total; results];
           
    end
end

results_total.Properties.VariableNames = header;

%% Write the final results table to a CSV file
writetable(results_total ,'missing_ERP_results.csv')
