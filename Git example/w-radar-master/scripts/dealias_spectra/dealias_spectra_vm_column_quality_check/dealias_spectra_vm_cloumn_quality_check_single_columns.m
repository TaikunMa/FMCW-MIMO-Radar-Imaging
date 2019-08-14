function [vm, correction] = dealias_spectra_vm_cloumn_quality_check_single_columns(vm, vn, idx, noise_fac, correction, varargin)

% this function corrects mean doppler velocities considering neighbouring
% columns

% input:
%   vm: mean Doppler velocity (time x height)
%   idx_columns: (time) index arrays indicating wrogly dealiased colmuns
%   vn: Nyquist velocities
%   idx: last bin to include
%   std_fac: factor of standard deviation that must be exceeded
%   correction that was applied
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


dv = nanmean(diff(vm(:,1:idx)),2);

noise = hildebrand_sekon(abs(dv)',1);

% find all columns that have a mean difference above peaknoise level by HS
idx_flag = abs(dv) > noise_fac*noise.peaknoise;

[block_start, block_end] = radar_moments_get_blocks_of_signal(idx_flag,[1,numel(dv)]);

dblocks = block_end - block_start + 1;

% get indexes where only one column has been dealiased wrongly,
% i.e. dv is de-/increases before the column and in-/decreases
% again after the column
idx_col = dblocks == 2;
idx_columns = block_end(idx_col);

correction_temp = correction;
% correct dv in all blocks
for i = 1:numel(idx_columns)
    
    % correct for all chirp sequences
    for ii = 1:numel(range_offsets)-1
        
        % get indexes in this chirp sequence
        r_idx = double(range_offsets(ii):range_offsets(ii+1)-1);
        
        % create mean of neighbouring velocities
        if idx_columns(i) == 1
            
            temp_neigh = vm(idx_columns(i)+1, r_idx);
            
        elseif idx_columns(i) == svm(1)
            
            temp_neigh = vm(idx_columns(i)-1, r_idx);
            
        else
            
            temp_neigh = nanmean( [vm(idx_columns(i)-1,r_idx); vm(idx_columns(i)+1, r_idx)], 1 );
            
        end
        
        % check if values in neighbouring bin are present
        idx_value = ~isnan(temp_neigh);        
        if sum(idx_value) < 2
            continue
        end
        
        % save indexes with signal to set interpolated values to zero
        idx_signal = ~isnan(vm(idx_columns(i),r_idx));
                 
        % interpolate nighbouring velocities
        vm_neighbour = interp1( r_idx(idx_value), temp_neigh(idx_value), r_idx, 'linear','extrap');
        
        % subtract/add vn, to correct for dealiasing into wrong
        % direction, i.e. causing an offset of +-k*2*v_n, k = 1,2,...,N
        corr_factor = [-4, -2. 0, 2, 4];
        
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
        
        
    end % for ii
    
end % for i

end % function
        