function results_peak_mean_lat = get_Amplitude_Latency(subj, channel, component)


switch component(1)
    case 'N'
        direction = -1;
    case 'P'
        direction = 1;
    otherwise
        print('component not recognized')
end

% Loop through subjects to load data and find amplitude and latency
% -------------------------------------------------------------------------
    
    % Initialise subject and filepath
    % ---------------------------------------------------------------------
%     subj = fileInfo(i).name;
%     subjFile = sprintf('D:/MDD16_Project/Raw_Data/%s', subj); 
%     cd(subjFile);
    
    % Load dataset
    % ---------------------------------------------------------------------
    load(sprintf('%s_%s_%s_avgCond1.mat', subj, channel, component));
    load(sprintf('%s_%s_%s_avgCond2.mat', subj, channel, component));
    
    % Local Peak Amplitude
    % ---------------------------------------------------------------------
    % Identify local peaks and maximum local peak value and index
    pks_cond1 = findpeaks(direction*data_cond1.avg(1,:));
    pks_cond2 = findpeaks(direction*data_cond2.avg(1,:));
    pk1 = direction*max(pks_cond1); pk2 = direction*max(pks_cond2);
    idx1 = find(data_cond1.avg == pk1); idx2 = find(data_cond2.avg == pk2);
    
    % Update results array
%     peakAmplitude(1, j) = pk1; peakAmplitude(2, j) = pk2;
    peakAmp = horzcat(pk1, pk2);
    % Mean Amplitude
    % ---------------------------------------------------------------------
    % Calculate the mean amplitude
    meanAmp_cond1 = mean(data_cond1.avg(1,:));
    meanAmp_cond2 = mean(data_cond2.avg(1,:));
    
    meanAmp = horzcat(meanAmp_cond1, meanAmp_cond2);
    
    % Latency at 50% ofpeak amplitude
    % ---------------------------------------------------------------------
    
    % Calculate 50% of peak amplitude   
    half_pk1 = 0.5 * pk1; half_pk2 = 0.5 * pk2;
    
    % Step backwards through data to find latency at 50% of peak amplitude
    % Condition 1
    latency1 = min(data_cond1.time);
    for i = idx1:-1:1
        try
            if direction == -1
                if half_pk1 > data_cond1.avg(i) && half_pk1 < data_cond1.avg(i-1)
                    upper = data_cond1.avg(i); lower = data_cond1.avg(i-1); % Find interval in data
                    upper_time = data_cond1.time(i); lower_time = data_cond1.time(i-1);
                    latency1 = interp1([upper, lower], [upper_time, lower_time], half_pk1, 'linear'); % Interpolate to get latency
                    break
                end
            elseif direction == 1
                 if half_pk1 < data_cond1.avg(i) && half_pk1 > data_cond1.avg(i-1)
                    upper = data_cond1.avg(i); lower = data_cond1.avg(i-1); % Find interval in data
                    upper_time = data_cond1.time(i); lower_time = data_cond1.time(i-1);
                    latency1 = interp1([upper, lower], [upper_time, lower_time], half_pk1, 'linear'); % Interpolate to get latency
                    break
                 end
            end
        catch
            latency1 = min(data_cond1.time);
        end
    end
    
    % Condition 2
    latency2 = min(data_cond2.time);
    for i = idx2:-1:1
        try
            if direction == -1
                if half_pk2 < data_cond2.avg(i) && half_pk2 > data_cond2.avg(i-1)
                    upper = data_cond2.avg(i); lower = data_cond2.avg(i-1); % Find interval in data
                    upper_time = data_cond2.time(i); lower_time = data_cond2.time(i-1);
                    latency2 = interp1([upper, lower], [upper_time, lower_time], half_pk2, 'linear'); % Interpolate to get latency
                    break
                end
            elseif direction == 1
                 if half_pk2 > data_cond2.avg(i) && half_pk2 < data_cond2.avg(i-1)
                    upper = data_cond2.avg(i); lower = data_cond2.avg(i-1); % Find interval in data
                    upper_time = data_cond2.time(i); lower_time = data_cond2.time(i-1);
                    latency2 = interp1([upper, lower], [upper_time, lower_time], half_pk2, 'linear'); % Interpolate to get latency
                    break
                 end
            end
        catch
            latency2 = min(data_cond2.time);
        end
    end
    
    % Update results array
    latency = horzcat(latency1, latency2);
    
    %% Gather All results
    results_peak_mean_lat = table(string(subj), string(channel), string(component), peakAmp(1), peakAmp(2), meanAmp(1), meanAmp(2), latency(1), latency(2));
    
end
