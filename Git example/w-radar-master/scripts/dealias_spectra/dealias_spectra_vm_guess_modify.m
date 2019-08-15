function vm_guess = dealias_spectra_vm_guess_modify(vm_prev_col, vn, vm_guess)

% input:
%   vm_prev_col: doppler velocities of neighbouring bin in previous
%       column, numel(vm_prev_col) must be uneven
%   vn: nyquist velocity
%   vm_guess: current guessed velocity
%
% output:
%   updated vm_guess

    s = floor(numel(vm_prev_col)/2);
    
    idx_nan = ~isnan(vm_prev_col);
    
    if sum(idx_nan) == 0 || s < 1 % then no guess available        
        return                
    else        
        weights = [1:s+1, s:-1:1];
        vm_guess_prev = nansum(vm_prev_col.*weights')./sum(weights(idx_nan));        
    end
        
    
    if vm_guess_prev > vm_guess % increase vm guess
        vm_guess = vm_guess + vn/4;
    else
        vm_guess = vm_guess - vn/4;
    end
    
end % function