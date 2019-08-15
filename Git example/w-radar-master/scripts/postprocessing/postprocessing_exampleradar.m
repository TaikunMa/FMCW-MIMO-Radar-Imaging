function [data, info] = postprocessing_exampleradar(data, info)
% corrections to radar data that are done after all the other processing
% took place

%% Ze corrections

% Before radar software version 5.0 need to correct for incorrectly 
% estimated receiver gain: factor of 2/adding +3 dB.

if data.time(1) < datetimeconv(2018,10,10,0,0,0) 
    % all data before 2018, October 10th (end of measurements at nya)
    
    data.Ze = data.Ze*2; % Ze in linear units, this is same as adding 3 dB in log scale
                         % data.Ze*2 = 10^( (10.*log10(data.Ze) + 3)/10 )

    data.Ze_label = 'Ze corrected with +3dB (to correct for receiver gain).';
    data.Ze_corr = 3;
end

