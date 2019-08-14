function vm_guess = dealias_spectra_vm_guess_qual_check(vm, vm_prev_col, ii, inc, dr,win)

% this function looks for vm_guess if the bordering bins in the column do
% not provide an estimate

% input
%   vm: mean Doppler velocity array of considered column
%   vm_prev_col: mean Doppler velocity array of previous time step
%   ii: index of considered bin
%   inc == -1 then dealiasing happens topdown
%   dr: range resolution in m
%
% output
%   vm_guess: initial guess doppler velocity


% topdown = false;
n = numel(vm);

% get number of indexes that are not closer than 50 meters
n_bins_curr = floor(win/dr);

% ######## create indexes for neighbour checks
idx_prev = ii-inc*max([floor(n_bins_curr/2), 1]):inc:ii+inc*max([floor(n_bins_curr/2), 1]);
idx_curr = ii-inc:-inc:ii-inc*max([1, n_bins_curr]);

% check if boundaries are exceeded
idx_valid = idx_prev > 0 & idx_prev <= n;
idx_prev = idx_prev(idx_valid);

idx_valid = idx_curr > 0 & idx_curr <= n;
idx_curr = idx_curr(idx_valid);
if isempty(idx_curr)
    idx_curr = NaN;
end

%  ############# check neigbours including previous column
vm_guess = dealias_spectra_vm_guess_qual_check_neighbour_check(vm, vm_prev_col, idx_curr, idx_prev, ii);
    
% if ~isnan(vm_guess)
%     return
% end

% % ############# extrapolate wind from previous bins with signal
% vm_guess = dealias_spectra_vm_guess_qual_check_gradient_check(vm, topdown, ii);


end

function vm_guess = dealias_spectra_vm_guess_qual_check_neighbour_check(vm, vm_prev_col, idx_curr, idx_prev, ii)

    vm_guess = NaN;
    
    if ~isnan(idx_curr) % check if the next to bins of the current column contain dealiased signal
        vm_guess = vm( find(~isnan(vm(idx_curr)),1) + idx_curr(1) - 1 );
    end
    
    if ~isnan(vm_guess)

        return
        
    else % check in neighbour column
        
        vm_guess = vm_prev_col(ii);
        
        if ~isnan(vm_guess)
            return

        elseif any(~isnan(vm_prev_col(idx_prev)))

            vm_guess = nanmean( vm_prev_col(idx_prev) );

        else

            vm_guess = NaN;

        end
        
    end

end % function

    
% function vm_guess = dealias_spectra_vm_guess_qual_check_gradient_check(vm, topdown, ii)
%     
%     vm_guess = NaN;
%     
%     if topdown == true % then dealiasing started from top
%         vm_array = vm(ii:ii+5,1);
%         idx = find(~isnan(vm_array));
%     else
%         vm_array = flip(vm(ii-5:ii,1));
%         idx = find(~isnan(vm_array));
%     end
%     
%     if numel(idx) < 2
%         return
%     end
%     
%     x_array = 1:6;
%     % extrapolate data
%     vm_array = interp1(x_array(idx),vm_array(idx),x_array,'linear','extrap');
%     vm_guess = vm_array(1);
%     
% 
% end