function [spec, flag] = radar_moments_check_significant_peaks(velocity, spec, idx_signal, skew)

% this function checks the significant peaks determined in
% radar_moments_from_spectra.m or
% radar_moments_from_spectra_and_different_chrip_seq.m
%
% input
%   velocity: doppler velocity array 
%   spec: doppler
%   idx_signal: logical array indicating signal
%   vm: mean doppler velocity
%   sigma: spectral width
%   skew(ness)

flag = false;
skew_threshold = 8;

sv = size(velocity);

% ######### identify serparate blocks
[block_start, block_end] = get_blocks_of_signal(idx_signal, sv);

n_blocks = numel(block_start);
if n_blocks == 1 % then there is only one block
    return;
end

% ######## get distances of peaks to mainpeak
[dv, block_width, idx_max, idx_mainpeak] = get_distance_to_mainpeak(block_start, block_end, spec, velocity);


% ###### identify all peaks with distance larger than 1.5 m/s to the main
% peak and a spectral width smaller than 50% of the main peak's width

idx_noise = abs(dv) > 1.5 & block_width/block_width(idx_mainpeak == idx_max) < 0.5;

if any(idx_noise) % then noise was detected
    for ii = 1:n_blocks
        if idx_noise(ii) == true
            spec(block_start(ii):block_end(ii)) = 0;
        end
    end
    
    % recalculate moments
    moments = radar_moments_call_moments(velocity, spec, 'skew');
    skew = moments.skew;
    
    flag = true;
    
end

% check skewness
if abs(skew) > skew_threshold % then there is still signal that is noise
    
    
    while abs(skew) > skew_threshold % get distance of max peak of those peaks that have not yet been assigned to be
        % noise
        
        idx_signal = spec > 0;
        
        % get blocks of signal
        [block_start, block_end] = get_blocks_of_signal(idx_signal, sv);
        
        % get distance to main peak
        dv = get_distance_to_mainpeak(block_start, block_end, spec, velocity);
        
        % set peak with largest distance to zero
        [~, idx_dv_max] = max(abs(dv));
        
        spec(block_start(idx_dv_max):block_end(idx_dv_max)) = 0;
        
        % recalculate skewness
        moments = radar_moments_call_moments(velocity, spec, 'skew');
        skew = moments.skew;
        
        if numel(block_start) == 1
            break
        end        
        
    end
    
    flag = true;
    
end


    


end % function


function [block_start, block_end] = get_blocks_of_signal(idx_signal,sv)
    
    % ######### identify serparate blocks
    idx_diff = diff(idx_signal);

    block_start = find(idx_diff == 1) + 1;
    block_end = find(idx_diff == -1);

    n_start = numel(block_start);
    n_end = numel(block_end);

    if n_start == 0 % then there is only one block reaching vn
        block_start(1) = 1;
    elseif n_end == 0
        block_end(1) = sv(2);
    end

    if block_end(1) < block_start(1) % then first block start at first bin
        block_start = [1, block_start];
    end

    if block_start(end) > block_end(end) % then last block goes until last bin
        block_end = [block_end, sv(2)];
    end
        
end % function



function [dv, block_width, idx_max, idx_mainpeak] = get_distance_to_mainpeak(block_start, block_end, spec, velocity)
    
    n_blocks = numel(block_end);
    block_max = NaN(1,n_blocks);
    idx_max = NaN(1,n_blocks);

    for ii = 1:n_blocks
       [block_max(ii), idx_max(ii)] = max(spec(block_start(ii):block_end(ii)));
    end
    idx_max = idx_max + block_start - 1;


    [~,idx_mainpeak] = max(spec(idx_max));
    idx_mainpeak = idx_max(idx_mainpeak);

    % ####### get distance to mainpeak
    dv = velocity(idx_mainpeak) - velocity(idx_max);

    % ###### spectral width
    block_width = velocity(block_end)-velocity(block_start);
    
end % function



        






