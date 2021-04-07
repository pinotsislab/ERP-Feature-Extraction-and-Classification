header = {'SubjID', 'Channel', 'Component', 'PeakAmp_Cond1', 'PeakAmp_Cond2', 'MeanAmp_Cond1', 'MeanAmp_Cond2', 'Latency_Cond1', 'Latency_Cond2'};
all_possible_channels =  {'Fp1' 'Fpz' 'Fp2' 'AF7' 'AF3' 'AFz' 'AF4' 'AF8' 'F7' 'F5' 'F3' 'F1' 'Fz' 'F2' 'F4' 'F6' 'F8' 'FT9' 'FT7' 'FC5' 'FC3' 'FC1' 'FCz' 'FC2' 'FC4' 'FC6' 'FT8' 'FT10' 'T9' 'T7' 'C5' 'C3' 'C1' 'Cz' 'C2' 'C4' 'C6' 'T8' 'T10' 'TP9' 'TP7' 'CP5' 'CP3' 'CP1' 'CPz' 'CP2' 'CP4' 'CP6' 'TP8' 'TP10' 'P9' 'P7' 'P5' 'P3' 'P1' 'Pz' 'P2' 'P4' 'P6' 'P8' 'HEOG' 'VEOG' 'ECG' 'P10' 'PO7' 'PO3' 'P0z' 'PO4' 'PO8' 'O1' 'Oz' 'O2' 'Iz'};
subj = {'hc001','hc003','hc004','hc006','hc007','hc008','hc009','hc010','hc011','hc012','hc014','hc015','hc016','hc017','hc018','hc019','hc020','hc021','hc022','hc023','hc024','hc025','hc026','hc027','hc028','hc029','hc031','hc033','hc035','hc036', 'hc037','hc042','hc044','hc045','pp001','pp002','pp003','pp004','pp005','pp006','pp007','pp008','pp009','pp010','pp011','pp013','pp014','pp015','pp016'};
conditions = {'Cond1', 'Cond2'};

total_iterations = length(all_possible_channels) + length(subj) + length(conditions);
results_total = table();

c = 0;
s = 0;
i = 0;

for c = 1:length(all_possible_channels)
    iteration_no = c+s+i;
    sprintf('Running iteration %s. Channel value is %s', iteration_no, all_possible_channels{c})
    
    for s = 1:length(subj)   
    
        sprintf('Running subject number %s. Subj_ID is %s', s, subj{s})
      
        for i = 1:length(conditions)
          
          load(sprintf('%s_%s_fullERP_avg%s.mat', subj{s}, all_possible_channels{c}, conditions{i}));
          
          if conditions{i} == 'Cond1'
              erp_timeseries = data_cond1.avg;
              
          elseif conditions{i} == 'Cond2'
              erp_timeseries = data_cond2.avg;
          else
              print("fail")
          end
          
          results = table(string(all_possible_channels{c}), string(subj{s}), string(conditions{i}), erp_timeseries);
          
          results_total = [results_total; results];
          
        end
    
    end
end