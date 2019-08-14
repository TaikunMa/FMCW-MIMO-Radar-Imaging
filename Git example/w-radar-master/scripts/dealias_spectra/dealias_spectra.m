
function [spec_out,vel_out,moments,alias_flag,status_flag] = ...
                    dealias_spectra(spec,vel,nAvg,dr,vm_prev_col,varargin)

% this function dealiases doppler spectra by
% - identifying a region where the mean doppler velocity is close to zero
% - using the mean doppler velocity of an already dealiased bin as initial
% guess for the neighbouring bins
% therefore the moments of the spectra must be calculated

% input:
%   spec = doppler spectra, rows contain different heights, columns
%          different velo-bins, units must be linear, fill value must be NaN
%   vel = doppler velocity array (matrix), rows contain velo-bins, columns
%         different chrip sequences
%   nAvg = number of spectral averages for each chirp sequence
%   dr = range resolution which is need to concatenate layer of signal if
%        there are gaps of a few bins
%   vm_prev_col= column of mean doppler velocity of previous column
%   varargin = contains further specifications
% 
%       varargin{1} = 'moment_str'; - specify highest moment to calculate,
%                                     that is given by varargin{2}
%       varargin{2} = 'vm';  - default is vm, options are 'Ze', 'vm', 
%                              'sigma', 'skew', 'kurt'
% 
%       varargin{3} = 'pnf'; - specify if mean ('mnf') or peak noise ('pnf')  
%                              used for noise clipping, factor given by
%                              next argument
%       varargin{4} = 1.2;   - default is 'pnf' and 1.2 
% 
%       varargin{5} = 'nbins'; - number of consectutive bins that are above
%                                varargin{4}*mean noise floor, so that
%                                program continues calculations (dealising,
%                                moment calculation)
%       varargin{6} = 3;       - default is 3
% 
%       varargin{7} = 'range_offsets'; - if more than one chirp included,
%                                       range_offsets need to be given
%       varargin{8} = range_offsets;   - array with range gate indexes for
%                                        each chirp 
% 
%       varargin{9} = 'linear'; - if spectra is given in dB-units,
%                                 conversion to linear space has to be done
% 
%       varargin{10} = 'comp_flag' - flag for determining if spectra is 
%                       compressed 
%       varargin{11} = flag_compress_spec - default is false
% 
%       varargin{12} = 'DualPol' - flag for Dual Pol given, default is zero
%       varargin{13} = 0 - single pol radar, 
%                      1 - dual pol radar LDR conf., 
%                      2 - dual pol radar STSR mode (dealiasing not
%                      programmed yet - July 20190
%       varargin{14} = spectra for horisontally received polarisation, when
%                      DualPol == 1
% 
% 
% output:
%   spec_out: dealiased spectra
%   vel_out: velocity arrays corresponding to new spectra
%   moments: radar moments of spectra
%   alias_flag == 1 where aliasing occurs
% status_flag = four bit binary/character that is converted into a real number.
%   no bit set, everything fine (bin2dec() = 0; or status_flag = '000'
%   bit 1 (2^0) = 1: '0001' no initial guess Doppler velocity
%       (vm_guess) before aliasing -> bin2dec() = 1
%   bit 2 (2^1) = 1: '0010' either sequence or upper or lower
%       bin boundary reached and vm_guess indicates too large
%       velocities, i.e. dealiasing not possible anymore
%   bit 3 (2^2) = 1: '0100' the largest values of the spectra
%       are located close to nyquist limit -> aliasing still
%       likelythe column mean difference to v_m
%       bins from the neighbouring column exceeds a threshold
%       -> i.e. dealiasing routine created too high/low v_m
%   bit 4 (2^3) = 1: the column mean difference to v_m
%       bins from the neighbouring column exceeds a threshold
%       -> i.e. dealiasing routine created too high/low v_m
%   combinations possible, e.g. '0101' = 5



% ##################### check input

ss = size(spec); % ss(1) = range dimension, e.g. spec(X,:)
                 % ss(2) = doppler velocity dimension, e.g. spec(:,Y)
sv = size(vel); % sv(1) - doppler velocity dimension, sv(2) - number of chirps 

if sv(2) > sv(1)
    vel = vel';
    sv = size(vel);
end

delv = vel(2,:)-vel(1,:); % vel = data.velocity, delv = velocity resolution for each chirp
vn = -vel(1,:); % nyquist velocity for each chirp

% check input options given by varargin, if not existing default options
% set
[moment_string, nf, nf_string, nbins, range_offsets, flag_compress_spec] = dealias_spectra_varargin_check(ss, varargin{:});



ix = find(strcmp(varargin,'DualPol'), 1);

if isempty(ix)
    flag_DualPol = 0;
    spec_hv = NaN(size(spec)); % dummy variable needed for function inputs
else % flag given as input
    
    flag_DualPol = varargin{ix+1};
    
    if flag_DualPol == 1
        spec_hv = varargin{ix+2};
    elseif flag_DualPol == 0
        spec_hv = NaN(size(spec));
    else
        disp('not done yet')
    end 
end 


% check if there is data
if flag_compress_spec
    if ~any(~isnan(spec(:))) % if any non-nan values found, don't continue
        return
    end

else
    if all(isnan(spec(:,1)))
        return
    end
end
    

% check unit of spectra - this should be unnecessary
if isempty(find(strcmp(varargin,'linear'), 1)) % convert into linear regime
    spec = 10.^(spec./10);
end

% if an isolated bin shows aliasing the next bin used as indicator has to
% be closer than max_dis
max_dis = 50;



% ####################### preallocate output data
moments.Ze = NaN(ss(1),1);
moments.vm = NaN(ss(1),1);
moments.sigma = NaN(ss(1),1);
moments.skew = NaN(ss(1),1);
moments.kurt = NaN(ss(1),1);
% moments.peaknoise = NaN(ss(1),1);
% moments.meannoise = NaN(ss(1),1);
% 
if flag_DualPol > 0
    moments.Ze_hv = NaN(ss(1),1);
    moments.vm_hv = NaN(ss(1),1);
    moments.LDR =  NaN(ss(1),1);
end

spec_out = spec;
vel_out = NaN(ss);

if sv(2) > 1 
    for ii = 1:ss(1)
        % get chirp indexes for each range gate
         r_idx = dealias_spectra_get_range_index(range_offsets, ii);
         vel_out(ii,:) = vel(:,r_idx)';
    end
end


% initialize flag
status_flag = zeros(ss(1),1); % if aliasing could be perform properliy
status_flag = dec2bin(status_flag,4); % convert to three binary string

% ############### get Nfft
Nfft = sum(~isnan(vel(:,:)));


% ###################### check aliasing
[alias_flag, noise] = dealias_spectra_check_aliasing(ss, spec, vel, nAvg, range_offsets, flag_compress_spec);

if ~flag_compress_spec 
    moments.peaknoise = noise.peaknoise;
    moments.meannoise = noise.meannoise;
end


% #################### check if aliasing occured in the column
if sum(alias_flag) == 0 % no aliasing occured, calculate moments from input spectra
    
    moments = radar_moments(spec,vel,nAvg,'noise',noise,'linear','range_offsets',range_offsets(1:end-1),'moment_str',moment_string,nf_string,nf,'nbins',nbins, 'compressed', flag_compress_spec, 'DualPol', flag_DualPol, spec_hv);
    return
    
end



% ##################### find cloud layers
% looks for cloud base and cloud top of all cloud layers
[cbh_fin, cth_fin] = dealias_spectra_find_cloud_layers(spec, range_offsets, dr, max_dis, flag_compress_spec);


% #################### start dealiasing every layer
for i = 1:numel(cbh_fin)

    % Looks for a range bin where no aliasing occurs starting from cloud
    % top down. This bin is used as reference in the next step (line 250->)!
    % if a non-dealiased bin is found, the function will calculate the 
    % higher moments in this bin
   
    [tempstruct, no_clean_signal, idx_0] = dealias_spectra_find_nonaliased_bin(cth_fin(i), cbh_fin(i), spec, range_offsets, vel, nAvg, moment_string, nf_string, nf, nbins, alias_flag, noise, Nfft(r_idx), flag_compress_spec, flag_DualPol, spec_hv);
    
    % write to output struct
    if no_clean_signal == false
        
        moments = dealias_spectra_write_tempmoments_to_finalmoments(moments, tempstruct, idx_0, moment_string);

    else % no non-dealiased singal was found; calculate moments for all bins
        
        for ii = cbh_fin(i):cth_fin(i)
                        
            % get range indexes
            r_idx = dealias_spectra_get_range_index(range_offsets, ii);

            if all( isnan( spec(ii,1:Nfft(r_idx)) ) ) || sum(spec(ii,1:Nfft(r_idx))) < 10^-20 % then no signal is available
                continue
            end
            
            tempnoise.meannoise = noise.meannoise(ii);
            tempnoise.peaknoise = noise.peaknoise(ii);
            
            tempstruct = radar_moments(spec(ii,1:Nfft(r_idx)),vel(1:Nfft(r_idx),r_idx),nAvg(r_idx),'noise',tempnoise,'moment_str',moment_string,'linear',nf_string,nf,'nbins',nbins, 'compressed', flag_compress_spec, 'DualPol', flag_DualPol, spec_hv(ii,1:Nfft(r_idx)));
            moments = dealias_spectra_write_tempmoments_to_finalmoments(moments, tempstruct, idx_0, moment_string);

        end
        
    end
    
    if all( isnan( moments.vm(cbh_fin(i):cth_fin(i),1) ) ) || cbh_fin(i) == cth_fin(i) % then no entry of this layer contains signal or it is only one bin
        continue
    end % if cc == nbins-1, then the lowest bin of this layer contains signal
    
    
    % ################ dealiase
    % start dealiasing topdown
    
    % 3 possibilities: the first non-dealised bin is between cloud base and 
    % top (a), at cloud top (b), or at cloud base (c)
    if (idx_0 ~= cbh_fin(i)) && (idx_0 ~= cth_fin(i)) % (a) then dealias in both directions
        
        % from idx_0 down to base
        [spec_out(cbh_fin(i):idx_0-1, :), vel_out(cbh_fin(i):idx_0-1, :), status_flag, moments] =...
            dealias_spectra_from_idxA_to_idxB(idx_0-1, cbh_fin(i), range_offsets, vel, delv, spec, vn,...
            moments, moment_string, nAvg, nf_string, nf, nbins, status_flag, dr, vm_prev_col, noise.peaknoise, flag_compress_spec, flag_DualPol, spec_hv);
        
        % from idx_0 up to top
        [spec_out(idx_0+1:cth_fin(i), :), vel_out(idx_0+1:cth_fin(i), :), status_flag, moments] =...
            dealias_spectra_from_idxA_to_idxB(idx_0+1, cth_fin(i), range_offsets, vel, delv, spec, vn,...
            moments, moment_string, nAvg, nf_string, nf, nbins, status_flag, dr, vm_prev_col, noise.peaknoise, flag_compress_spec, flag_DualPol, spec_hv);
        
    elseif (idx_0 ~= cbh_fin(i)) % (b) only topdown
        
        [spec_out(cbh_fin(i):idx_0-1, :), vel_out(cbh_fin(i):idx_0-1, :), status_flag, moments] =...
            dealias_spectra_from_idxA_to_idxB(idx_0-1, cbh_fin(i), range_offsets, vel, delv, spec, vn,...
            moments, moment_string, nAvg, nf_string, nf, nbins, status_flag, dr, vm_prev_col, noise.peaknoise, flag_compress_spec, flag_DualPol, spec_hv);        
        
    else % (c) only downtop
        
        [spec_out(idx_0+1:cth_fin(i), :), vel_out(idx_0+1:cth_fin(i), :), status_flag, moments] =...
            dealias_spectra_from_idxA_to_idxB(idx_0+1, cth_fin(i), range_offsets, vel, delv, spec, vn,...
            moments, moment_string, nAvg, nf_string, nf, nbins, status_flag, dr, vm_prev_col, noise.peaknoise, flag_compress_spec, flag_DualPol, spec_hv);
            
        
    end
    
    


end % for i = 

    

end  % function





    

