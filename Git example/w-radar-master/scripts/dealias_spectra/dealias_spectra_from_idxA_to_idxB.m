function [spec_out, vel_out, status_flag, moments] =...
    dealias_spectra_from_idxA_to_idxB(idxA,...  %  start index
    idxB,...            % end index
    range_offsets,...   % index where chirp sequences start
    vel,...             % velocity array containing Doppler velocity bins for each chirp sequence
    delv,...            % Doppler velocity resolution
    spec,...            % spectra full column
    vn,...              % nyquist velocity for each chirp sequence
    moments,...         % struct containing radar moments in the entire column
    moment_string,...   % string indicating highest moment to be calculated
    nAvg,...            % number of spectral averages
    nf_string,...       % indicating if mean or peak noise factor is taken for radar_moments
    nf,...              % noise factor
    nbins,...           % number of consecutive bins in for peak detection in radar_moments
    status_flag,...     % status flag of full column
    dr,...              % range resolution
    vm_prev_col,...     % mean doppler velocity of previous column
    peaknoise, ...      % peak noise of raw spectra
    flag_compress_spec,... % flag for compressed spectra
    flag_DualPol, ...   % flag for polarisation state
    spec_hv)            % spectra for cross-polarisation (could be dummy)

% output:
%   spec_out: dealiased spectra of layer
%   vel_out: velocity array for each spectrum
%   status_flag = true, if problem occured
%   moments: radar moments calculated from dealiased spectra


% ########### check into which direction the dealiasing should take place
if idxA < idxB % from bottom to top
    inc = 1;
else
    inc = -1;
end

% ######### preallocate variables
ss = size(spec);
idx = idxA:inc:idxB;
n_levels = numel(idx); % from top to bottom

spec_out = spec(idx,:);
vel_out = NaN(n_levels,ss(2));

if flag_DualPol > 0
    spec_hv_out = spec_hv(idx,:);
else
    spec_hv_out = NaN(size(spec_out));
end

tempflag = false(size(ss(1))); % indicates if spectra were determined correctly

Nfft = sum(~isnan(vel));

cc = 0;
for ii = idxA:inc:idxB % 

    cc = cc + 1;

    % ############### get range indexes
    r_idx = dealias_spectra_get_range_index(range_offsets, ii);
  
    if all( isnan(spec(ii,1:Nfft(r_idx))) ) || nansum(spec(ii,1:Nfft(r_idx)),2) < 1e-20 % then no signal is available
        continue
    end
    
    % ############## get spec and vel chains
    % make a celovity array that is 5 times wider than the original, with
    % the same doppler resolution
    vel_chain = (vel(1,r_idx) - 3*Nfft(r_idx)*delv(r_idx)) : delv(r_idx) : (vel(Nfft(r_idx),r_idx)+3*Nfft(r_idx)*delv(r_idx) + delv(r_idx));    
    
    % check if chrip boundary is approached
    [~,idx] = min(abs(ii-range_offsets));
    next_chirp = range_offsets(idx);
    
    % check if boundaries are exceeded
    if ii - inc > ss(1) || ii -inc < 1
        vm_guess = NaN;
    else
        vm_guess = moments.vm(ii-inc);
        
    end
    
    % check here if vm_guess has signal
    if isnan(vm_guess)
        % if doppler velocity at ii-inc is NaN, the function tries to find
        % another guess vm:
        % 1. looks for another reference velocity in the same column. Last
        %    vel_win m are considered, and the nearest value is taken.
        % 2. If no value found in the same column, the value of the same
        %    range of the previous time step is taken.
        % 3. If still no value found, average of +-vel_win/2 m of the previous
        %    time step is taken.
        % If none of the options leads to a guess velocity, NaN is returned.
        vel_win = 50;
        while isnan(vm_guess) && vel_win <= 200
            
            vm_guess = dealias_spectra_vm_guess_qual_check(moments.vm, vm_prev_col, ii, inc, dr(r_idx), vel_win);
            vel_win = vel_win*2;
        end
    end
    
%     vm_quality_check(vm_prev_col, )
    
    if vm_guess < -4*vn(r_idx)
        vm_guess = -4*vn(r_idx);
                
    elseif vm_guess > 4*vn(r_idx)
        vm_guess = 4*vn(r_idx);
       
    end
        
    % check if upper or lower boundary is reached
    % spectra from 5 bins is concatenated to spec_chain
    [spec_chain, status_flag(ii,1:4)] = dealias_spectra_concetenate_spectra(vm_guess, spec(:,1:Nfft(r_idx)), vn(r_idx), ii, next_chirp, Nfft(r_idx));
    
    %################ get final spectrum    
    
    [spec_out(cc,1:Nfft(r_idx)), vel_out(cc,1:Nfft(r_idx)), status_flag(ii,1:4)] = dealias_spectra_determine_final_spectrum(vm_guess, spec_chain, vel_chain, Nfft(r_idx), flag_compress_spec);

    %############## quality check final spectrum
    alias_flag = dealias_spectra_quality_check_final_spectrum(spec_out(cc,1:Nfft(r_idx)), peaknoise(ii), flag_compress_spec);
    
  
    % ############ if alias_flag == 1, then try centering again with
    % modified vm_guess and get vm
    if alias_flag == 1
        % use adjacent velocities to get a new vm_guess, make sure that
        % indexes do not exceed boundaries
        a = ii - 2; if a == -1, a = 1; elseif a == 0, a = 2; end
        b = ii + 2; if b == ss(1) + 2, b = ss(1); elseif b == ss(1) + 1, b = ss(1) - 1;  end
        
        vm_guess_new = dealias_spectra_vm_guess_modify(vm_prev_col(a:b), vn(r_idx), vm_guess);

        if (vm_guess_new ~= vm_guess) && ~isnan(vm_guess_new) % then determine spectrum again
            [spec_out(cc,1:Nfft(r_idx)), vel_out(cc,1:Nfft(r_idx)), status_flag(ii,1:4)] = dealias_spectra_determine_final_spectrum(vm_guess_new, spec_chain, vel_chain, Nfft(r_idx), flag_compress_spec);
            
            %############## quality check final spectrum again
            alias_flag = dealias_spectra_quality_check_final_spectrum(spec_out(cc,1:Nfft(r_idx)), peaknoise(ii), flag_compress_spec);
        end
               
    end
   
    
    % if dual pol, dealias spec_hv
    if flag_DualPol > 0
        
        [spec_chain_hv, ~] = dealias_spectra_concetenate_spectra(vm_guess, spec_hv(:,1:Nfft(r_idx)), vn(r_idx), ii, next_chirp, Nfft(r_idx));

        ind1 = find(vel_chain == vel_out(cc,1));
        ind2 = find(vel_chain == vel_out(cc,Nfft(r_idx)));
        spec_hv_out(cc,1:Nfft(r_idx)) =  spec_chain_hv(ind1:ind2);
        
        if flag_DualPol == 2
            disp('De-aliasing of fully polarimetric spectral capability not done')
        end
    end
    
    % ############## calculate moments
    tempstruct = radar_moments(spec_out(cc,1:Nfft(r_idx)),vel_out(cc,1:Nfft(r_idx)),nAvg(r_idx),'moment_str',moment_string,'linear',nf_string,nf,'nbins',nbins, 'compressed', flag_compress_spec, 'DualPol', flag_DualPol, spec_hv_out(cc,1:Nfft(r_idx)));
    moments = dealias_spectra_write_tempmoments_to_finalmoments(moments, tempstruct, ii, moment_string);

    
    if alias_flag == 1 % then centering did not work properly all follwing bins might be affected
        tempflag(ii:inc:idxB) = true;
    end
        
    
    
    
end % ii


if idxA > idxB % flip order of output
    spec_out = flip(spec_out,1);
    vel_out = flip(vel_out,1);
end

% update status_flag
status_flag(tempflag == true,2) = '1';
