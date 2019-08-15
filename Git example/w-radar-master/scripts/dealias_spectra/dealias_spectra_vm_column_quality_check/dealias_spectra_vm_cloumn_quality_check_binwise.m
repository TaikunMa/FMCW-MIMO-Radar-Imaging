function [vm, correction, status] = dealias_spectra_vm_cloumn_quality_check_binwise(vm, vn, correction, varargin)

% input:
%   vm: mean doppler velocity
%   vm: nyquist velocity
%   correction: correction that was already applied to wrongly aliased bins
%       in m/s
%   varargin: can contain range_offsets    
%
% output:
%   status: status of deliasing: true == problem


% ###### initial checks
svm = size(vm);

status = false(svm);
dbin = 5;
dvm = 5;


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

correction_temp = correction;
vm_temp = vm;
for i = 1:svm(1)
    
    a = i - dbin;
    b = i + dbin;
    c = i - 1;
    d = i + 1;
    
    if a < 1,  a = 1; end
    
    if b > svm(1), b = svm(1); end
    
    if c < 1, c = 1; end
    
    if d > svm(1), d = svm(1); end
   
    vm_neighbour = nanmean(vm(a:c,:))/2 + nanmean(vm(d:b,:))/2;
    idx_signal_neigh = ~isnan(vm_neighbour);
    yy = 1:svm(2);
    vm_neighbour = interp1( yy(idx_signal_neigh), vm_neighbour(idx_signal_neigh), yy, 'linear','extrap');
    
    % correct for all chirp sequences
    for ii = 1:numel(range_offsets)-1
        
        % get indexes in this chirp sequence
        r_idx = double(range_offsets(ii):range_offsets(ii+1)-1);      
       
        % subtract/add vn, to correct for dealiasing into wrong
        % direction, i.e. causing an offset of +-k*2*v_n, k = 0,1,2
        corr_factor = [-4, -2. 0, 2, 4];
        
        % save indexes with signal to set interpolated values to zero
        idx_signal = ~isnan(vm(i,r_idx)) & abs(vm(i,r_idx) - vm_neighbour(r_idx)) > dvm;
        
        if ~any(idx_signal) % nothing to correct
            continue
        end
        
        vm_opt = [vm(i,r_idx) + corr_factor(1)*vn(ii) - vm_neighbour(r_idx);...
            vm(i,r_idx) + corr_factor(2)*vn(ii) - vm_neighbour(r_idx); ...
            vm(i,r_idx) + corr_factor(3)*vn(ii) - vm_neighbour(r_idx);...
            vm(i,r_idx) + corr_factor(4)*vn(ii) - vm_neighbour(r_idx);...
            vm(i,r_idx) + corr_factor(5)*vn(ii) - vm_neighbour(r_idx)];
        
        % get row index with minum value, i.e. the correction
        % factor
        [~, idx_min] = min(abs(vm_opt));
        
        for iii = 1:numel(corr_factor)
            
            idx_corr = idx_min == iii;
            % correct vm
            correction(i,r_idx(idx_corr)) = corr_factor(iii)*vn(ii);
            vm(i,r_idx(idx_corr)) = vm(i,r_idx(idx_corr)) + correction(i,r_idx(idx_corr));
            
        end % for iii
        
        % get rid of artificial signal from interpolating vm_neighbour
        vm(i,r_idx(~idx_signal)) = vm_temp(i,r_idx(~idx_signal));
        correction(i,r_idx(~idx_signal)) = correction_temp(i,r_idx(~idx_signal));
        
        
    end % for ii
    
end
    