function [vm, correction] = dealias_spectra_vm_cloumn_quality_check_mean_column_values(vm, vn, idx, correction, varargin)

% this function corrects mean doppler velocities considering neighbouring
% columns

% input:
%   vm: mean Doppler velocity (time x height)
%   idx_columns: (time) index arrays indicating wrogly dealiased colmuns
%   vn: Nyquist velocities
%   idx: last bin to include
%   correction: value that must be added to the velocity offset
%   varargin:
%      range_offsets: start of chirp sequences
%
% output:
%   vm: corrected mean Doppler velocities
%   correction: value that must be added to the velocity offset


% ######## initial checks
svm = size(vm);
vm_mean = nanmean(vm(:,1:idx),2);


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

%####### identify all values that deviate more than 5 m/s from the average within
% +- 10 bin

dbin = 5;
dvm = 5;

correction_temp = correction;
for i = 1:svm(1)
    
    a = i - dbin;
    b = i + dbin;
    c = i - 1;
    d = i + 1;
    
    if a < 1,  a = 1; end
    
    if b > svm(1), b = svm(1); end
    
    if c < 1, c = 1; end
    
    if d > svm(1), d = svm(1); end
   
    tempmean = nanmean(vm_mean(a:c))/2 + nanmean(vm_mean(d:b))/2;
    if abs(vm_mean(i) - tempmean) < dvm || isnan(tempmean) || isnan(vm_mean(i))
        continue
    end
    
    vm_prof = nanmean(vm(a:i-1,:))/2 + nanmean(vm(i+1:b,:))/2;
    
    % correct for all chirp sequences
    for ii = 1:numel(range_offsets)-1
        
        % get indexes in this chirp sequence
        r_idx = double(range_offsets(ii):range_offsets(ii+1)-1);      
        
        
        % check if vm_prof contains signal
        idx_value = ~isnan(vm_prof(r_idx));
        if sum(idx_value) < 2
            continue
        end
        
        % interpolate nighbouring velocities
        vm_neighbour = interp1( r_idx(idx_value), vm_prof(idx_value), r_idx, 'linear','extrap');
        
        % subtract/add vn, to correct for dealiasing into wrong
        % direction, i.e. causing an offset of +-k*2*v_n, k = 1,2,...,N
        corr_factor = [-4, -2. 0, 2, 4];
        
        % save indexes with signal to set interpolated values to zero
        idx_signal = ~isnan(vm(i,r_idx));
        
        vm_opt = [vm(i,r_idx) + corr_factor(1)*vn(ii) - vm_neighbour;...
            vm(i,r_idx) + corr_factor(2)*vn(ii) - vm_neighbour; ...
            vm(i,r_idx) + corr_factor(3)*vn(ii) - vm_neighbour;...
            vm(i,r_idx) + corr_factor(4)*vn(ii) - vm_neighbour;...
            vm(i,r_idx) + corr_factor(5)*vn(ii) - vm_neighbour];
        
        % get row index with minum value, i.e. the correction
        % factor
        [~, idx_min] = min(abs(vm_opt));
        
        for iii = 1:numel(corr_factor)
            
            idx_corr = idx_min == iii;
            % correct vm
            correction(i,r_idx(idx_corr)) = correction(i,r_idx(idx_corr)) + corr_factor(iii)*vn(ii);
            vm(i,r_idx(idx_corr)) = vm(i,r_idx(idx_corr)) + corr_factor(iii)*vn(ii);
            
        end % for iii
        
        % get rid of artificial signal from interpolating vm_neighbour
        vm(i,r_idx(~idx_signal)) = NaN;
        correction(i,r_idx(~idx_signal)) = correction_temp(i,r_idx(~idx_signal));
        
        
        
    end % for ii
    
end % for i