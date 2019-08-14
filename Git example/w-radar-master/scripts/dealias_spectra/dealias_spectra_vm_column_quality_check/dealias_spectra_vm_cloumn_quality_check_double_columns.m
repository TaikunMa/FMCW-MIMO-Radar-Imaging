function [vm, correction] = dealias_spectra_vm_cloumn_quality_check_double_columns(vm, vn, idx, noise_fac, correction, varargin)

% this function corrects mean doppler velocities considering neighbouring
% columns

% input:
%   vm: mean Doppler velocity (time x height)
%   idx_columns: (time) index arrays indicating wrogly dealiased colmuns
%   vn: Nyquist velocities
%   idx: last bin to include
%   noise_fac: factor of peaknoise level that must be exceeded
%   correction: value that must be added to the velocity offset
%   varargin:
%      range_offsets: start of chirp sequences
%
% output:
%   vm: corrected mean Doppler velocities
%   correction: value that must be added to the velocity offset


% ######## initial checks
svm = size(vm);

if vn(1) < 0
    vn = abs(vn);
end

% check varargin
if isempty(varargin)
    
    range_offsets = [1, svm(2)];
    
else
    
    range_offsets = varargin{1};
    
    if numel(range_offsets) == numel(vn)
        
        range_offsets(end+1) = svm(2) + 1;
        
    elseif ne(range_offsets(end), svm(2)+1)
        
        range_offsets(end) = svm(2) + 1;
        
    end
    
end


% ########## get mean dv
dv = nanmean(diff(vm(:,1:idx)),2);


% ########## get peaknpise level
noise = hildebrand_sekon(abs(dv)',1);


% ########## find all columns that have a mean difference above peaknoise level by HS
idx_flag = abs(dv) > noise_fac*noise.peaknoise;


% ########## get start and end of blocks of adjacent abs(dv) bins that exceed the peaknoise
[block_start, block_end] = radar_moments_get_blocks_of_signal(idx_flag,[1,numel(dv)]);
% get size of blocks
block_size = block_end - block_start + 1;
block_distance = [block_start(2:end) - block_end(1:end-1), NaN];
n_blocks = numel(block_start);


% ######### get indexes where two peaks are sparated by only one bin -> double column

idx_columns = NaN(1,n_blocks);
if block_distance(1) == 2 && block_distance(2) > 3 && ...
            block_size(1) == 1 && block_size(2) == 1
        idx_columns(1) = block_start(1);
end

i = 2;
while i < n_blocks
    
    if block_distance(i) == 2 && block_distance(i-1) > 3 && block_distance(i+1) > 3 && ...
            block_size(i) == 1 && block_size(i+1) == 1
        
        idx_columns(i) = block_start(i) + 1;
        i = i + 2;
    else
        i = i + 1;
    end
end

% get rid of NaN
idx_columns = idx_columns(~isnan(idx_columns));

correction_temp = correction;

%######### correct dv in all blocks
for i = 1:numel(idx_columns)
    
    % correct for all chirp sequences
    for ii = 1:numel(range_offsets)-1
        
        % get indexes in this chirp sequence
        r_idx = double(range_offsets(ii):range_offsets(ii+1)-1);
        
        % create mean of neighbouring velocities
        if idx_columns(i) == 1
            
            temp_neigh = vm(idx_columns(i)+2, r_idx);
            
        elseif idx_columns(i) == svm(1)
            
            temp_neigh = vm(idx_columns(i)-1, r_idx);
            
        else
            
            temp_neigh = nanmean( [vm(idx_columns(i)-1,r_idx); vm(idx_columns(i)+2, r_idx)], 1 );
            
        end
        
        % check if values in neighbouring bin are present
        idx_value = ~isnan(temp_neigh);        
        if sum(idx_value) < 2
            continue
        end
        
                    
        % interpolate nighbouring velocities
        vm_neighbour = interp1( r_idx(idx_value), temp_neigh(idx_value), r_idx, 'linear','extrap');
        
        % subtract/add vn, to correct for dealiasing into wrong
        % direction, i.e. causing an offset of +-k*2*v_n, k = 1,2,...,N
        corr_factor = [-4, -2. 0, 2, 4];
        
        
        % ###### do first column
        
        % save indexes with signal to set interpolated values to zero
        idx_signal = ~isnan(vm(idx_columns(i),r_idx));
        
        vm_opt = [vm(idx_columns(i),r_idx) + corr_factor(1)*vn(ii) - vm_neighbour;...
            vm(idx_columns(i),r_idx) + corr_factor(2)*vn(ii) - vm_neighbour; ...
            vm(idx_columns(i),r_idx) + corr_factor(3)*vn(ii) - vm_neighbour;...
            vm(idx_columns(i),r_idx) + corr_factor(4)*vn(ii) - vm_neighbour;...
            vm(idx_columns(i),r_idx) + corr_factor(5)*vn(ii) - vm_neighbour];
        
        % get row index with minum value, i.e. the correction
        % factor
        [~, idx_min] = min(abs(vm_opt));
        
        for iii = 1:numel(corr_factor)
            
            idx_corr = idx_min == iii;
            % correct vm
            correction(idx_columns(i),r_idx(idx_corr)) = correction(idx_columns(i),r_idx(idx_corr)) + corr_factor(iii)*vn(ii);
            vm(idx_columns(i),r_idx(idx_corr)) = vm(idx_columns(i),r_idx(idx_corr)) + corr_factor(iii)*vn(ii);
            
        end % for iii
        
        vm(idx_columns(i),r_idx(~idx_signal)) = NaN;
        correction(idx_columns(i),r_idx(~idx_signal)) = correction_temp(idx_columns(i),r_idx(~idx_signal));
        
        % ###### do second column
        
        % save indexes with signal to set interpolated values to zero
        idx_signal = ~isnan(vm(idx_columns(i)+1,r_idx));
        
        vm_opt = [vm(idx_columns(i)+1,r_idx) + corr_factor(1)*vn(ii) - vm_neighbour;...
            vm(idx_columns(i)+1,r_idx) + corr_factor(2)*vn(ii) - vm_neighbour; ...
            vm(idx_columns(i)+1,r_idx) + corr_factor(3)*vn(ii) - vm_neighbour;...
            vm(idx_columns(i)+1,r_idx) + corr_factor(4)*vn(ii) - vm_neighbour;...
            vm(idx_columns(i)+1,r_idx) + corr_factor(5)*vn(ii) - vm_neighbour];
        
        % get row index with minum value, i.e. the correction
        % factor
        [~, idx_min] = min(abs(vm_opt));
        
        for iii = 1:numel(corr_factor)
            
            idx_corr = idx_min == iii;
            % correct vm
            correction(idx_columns(i)+1,r_idx(idx_corr)) = correction(idx_columns(i)+1,r_idx(idx_corr)) + corr_factor(iii)*vn(ii);
            vm(idx_columns(i)+1,r_idx(idx_corr)) = vm(idx_columns(i)+1,r_idx(idx_corr)) + corr_factor(iii)*vn(ii);
            
        end % for iii
        
        vm(idx_columns(i)+1,r_idx(~idx_signal)) = NaN;
        correction(idx_columns(i)+1,r_idx(~idx_signal)) = correction_temp(idx_columns(i)+1,r_idx(~idx_signal));
        
        
    end % for ii
    
end % for i

end % function
        
