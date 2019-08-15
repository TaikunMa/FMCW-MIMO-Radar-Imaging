function [vm, correction] = dealias_spectra_vm_cloumn_quality_check_all_columns(vm, vn, idx, noise_fac, correction, varargin)

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
 
 max_it = 500;
 idx_flag_compare = ones(1,max_it);
 
 cc = 1;
 vm_temp = vm;
 correction_temp = correction;
 
 % vm_old = vm;
while  any(abs(dv) > noise_fac*noise.peaknoise) && noise.peaknoise > 1 && max(abs(dv)) > 2 && cc < max_it
    
    cc = cc + 1;
    % ########## get mean dv
    dv = nanmean(diff(vm_temp(:,1:idx)),2);

    % ########## get peaknpise level
    noise = hildebrand_sekon(abs(dv)',1);

    % ########## find first column that has a mean difference above peaknoise level by HS
    idx_flag = find(abs(dv) > noise_fac*noise.peaknoise,1,'first') + 1;
    
    if isempty(idx_flag) % then there is no signal
        break
    end
    
    % ######### if column is again identified as peak set vm_temp to NaN
    % and skip this peak
    idx_flag_compare(cc) = idx_flag;
    if idx_flag_compare(cc-1) == idx_flag % set dv to zero to go to next interation
        vm_temp(idx_flag,:) = NaN;
        continue
    end       
    
    if idx_flag ==  1 % then already first bin is aliased
        a = 2;
        b = 20;
    else % consider 20 bins before
        a = idx_flag - 20;
        b = idx_flag;
        if a < 1
            a = 1;
        end
    end
    
    % ########## get mean profile of the last 60 seconds
    vm_prof = nanmean(vm(a:b,:));
        
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
        idx_signal = ~isnan(vm(idx_flag,r_idx));
        
        vm_opt = [vm(idx_flag,r_idx) + corr_factor(1)*vn(ii) - vm_neighbour;...
            vm(idx_flag,r_idx) + corr_factor(2)*vn(ii) - vm_neighbour; ...
            vm(idx_flag,r_idx) + corr_factor(3)*vn(ii) - vm_neighbour;...
            vm(idx_flag,r_idx) + corr_factor(4)*vn(ii) - vm_neighbour;...
            vm(idx_flag,r_idx) + corr_factor(5)*vn(ii) - vm_neighbour];
        
        % get row index with minum value, i.e. the correction
        % factor
        [~, idx_min] = min(abs(vm_opt));
        
        for iii = 1:numel(corr_factor)
            
            idx_corr = idx_min == iii;
            % correct vm
            correction(idx_flag,r_idx(idx_corr)) = correction(idx_flag,r_idx(idx_corr)) + corr_factor(iii)*vn(ii);
            vm(idx_flag,r_idx(idx_corr)) = vm(idx_flag,r_idx(idx_corr)) + corr_factor(iii)*vn(ii);
            
        end % for iii
        
        % get rid of artificial signal from interpolating vm_neighbour
        vm(idx_flag,r_idx(~idx_signal)) = NaN;
        correction(idx_flag,r_idx(~idx_signal)) = correction_temp(idx_flag,r_idx(~idx_signal));
        
        % update vm temp
        vm_temp(idx_flag,:) = vm(idx_flag,:);
        
        
    end % for ii
    
    
end  % while



