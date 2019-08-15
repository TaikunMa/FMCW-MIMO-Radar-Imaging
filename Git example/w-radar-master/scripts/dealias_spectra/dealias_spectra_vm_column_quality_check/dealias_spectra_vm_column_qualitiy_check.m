function [status, vm, correction] = dealias_spectra_vm_column_qualitiy_check(vm, range, status, vn, correction, varargin)

% this function corrects mean Doppler velocity columnwise by comparing
% several columns

% input
%   vm: mean Doppler velocity (time x height)
%   range: range [m]
%   status: dealias status
%   vn: nyquist velocity of each chrip sequence
%   varargin: range_offsets when several chrip sequnces are provided
%
% output
%   status
%   vm corrected
%   correction: that must be added to data.MinVel matrix in
%       process_joyrad94_data.m
      


% ########### preallocate/ set variables
noise_fac = 1;

% ########### initial check
idx = length(range);
% idx = find(range > 2000,1,'first') - 1;
% 
% dv = nanmean(diff(vm(:,idx(1):idx(2))),2);
% noise = hildebrand_sekon(abs(dv)',1);
% 
% if max(abs(dv)) < 2 && noise.peaknoise < 1 % then column is clean
%     return
% end
% 


% ##################### compare columns with respect to the mean difference
% of adjacent bins

% ############# correct single columns that were wrongly dealiased
[vm, correction] = dealias_spectra_vm_cloumn_quality_check_single_columns(vm , vn, idx, noise_fac, correction, varargin{:});

% ############ correct blocks with two adjacent columns that were dealiased
% wrongly
[vm, correction] = dealias_spectra_vm_cloumn_quality_check_double_columns(vm , vn, idx, noise_fac, correction, varargin{:});

% ########## correct rest of columns
[vm, correction] = dealias_spectra_vm_cloumn_quality_check_all_columns(vm , vn, idx, noise_fac, correction, varargin{:});



% ##################### compare columns with respect to their mean column
% values
% ######### check for absolute valus of vm mean
[vm, correction] = dealias_spectra_vm_cloumn_quality_check_mean_column_values(vm, vn, idx, correction, varargin{:});




% ##################### last check and flag data
status = dealias_spectra_vm_cloumn_quality_check_flag_data(vm, status);
    
        
end % function
