% Mess around with data to get Topoplot of ERP signals


%% Section 1, Global Settings

%% Prepare global variables

% list of subj numbers to loop through
subj = {'hc001','hc003','hc004','hc006','hc007','hc008','hc009','hc010','hc011','hc012','hc014','hc015','hc016','hc017','hc018','hc019','hc020','hc021','hc022','hc023','hc024','hc025','hc026','hc027','hc028','hc029','hc031','hc033','hc035','hc036', 'hc037','hc042','hc044','hc045','pp001','pp002','pp003','pp004','pp005','pp006','pp007','pp008','pp009','pp010','pp011','pp013','pp014','pp015','pp016'};
%%% 'pp012' is missing from the correct epochs
all_possible_channels =  {'Fp1' 'Fpz' 'Fp2' 'AF7' 'AF3' 'AFz' 'AF4' 'AF8' 'F7' 'F5' 'F3' 'F1' 'Fz' 'F2' 'F4' 'F6' 'F8' 'FT9' 'FT7' 'FC5' 'FC3' 'FC1' 'FCz' 'FC2' 'FC4' 'FC6' 'FT8' 'FT10' 'T9' 'T7' 'C5' 'C3' 'C1' 'Cz' 'C2' 'C4' 'C6' 'T8' 'T10' 'TP9' 'TP7' 'CP5' 'CP3' 'CP1' 'CPz' 'CP2' 'CP4' 'CP6' 'TP8' 'TP10' 'P9' 'P7' 'P5' 'P3' 'P1' 'Pz' 'P2' 'P4' 'P6' 'P8' 'HEOG' 'VEOG' 'ECG' 'P10' 'PO7' 'PO3' 'P0z' 'PO4' 'PO8' 'O1' 'Oz' 'O2' 'Iz'};
conditions = {'1' '2'};
% add fieldtrip to the path
% addpath C:\Users\fitzg\Documents\MATLAB\fieldtrip-20201009\fieldtrip-20201009
addpath("C:\Program Files\MATLAB\R2020b\toolbox\fieldtrip-20201214")
ft_defaults

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

correct_epoch_dir = "C:\Users\New Owner\Documents\MATLAB\MDD classification ERP\correct epochs";


%% Section 2, Load data and compute Grand averages
cd('C:\Users\New Owner\Documents\MATLAB\MDD classification ERP\Full_ERP_data');

iter = 0;
subj_avgs_cond1 = {};

for i=1:length(subj)
    
    iter = iter+1;
    [avg_cond1, avg_cond2] = getSubjAverage(subj{i}, timeStart, timeEnd, component, correct_epoch_dir);
    
    subj_avgs_cond1{i} = avg_cond1;
    subj_avgs_cond2{i} = avg_cond2;
end
    cfg = [];
    grandAvg1  = ft_timelockgrandaverage(cfg, subj_avgs_cond1{:});
    grandAvg2  = ft_timelockgrandaverage(cfg, subj_avgs_cond2{:});  
    

%% Section 4, plot the topoplot

%reset cfg structure which is reused for every fieldtrip command ...
cfg = [];
cfg.layout = 'EEG1010.lay'; % list of layout templates found here: https://www.fieldtriptoolbox.org/template/layout/#with-a-more-realistic-display-of-temporal-sensors-1
figure; ft_multiplotER(cfg, grandAvg1, grandAvg2)

