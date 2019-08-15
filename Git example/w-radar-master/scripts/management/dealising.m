function [data] = dealising(data)

specsize = size(data.spec);

data.AntiAlias = 2;

% preallocate moments
data.Ze = NaN(specsize(1:2));
data.vm =  NaN(specsize(1:2));
data.sigma =  NaN(specsize(1:2));
data.skew =  NaN(specsize(1:2));
data.kurt =  NaN(specsize(1:2));
if data.DualPol
    data.LDR = NaN(specsize(1:2));
end

% oldspec = data.spec;  
for i = 1:numel(data.time)
    
    temp = squeeze(data.spec(i,:,:));

    if data.DualPol > 0
        temp_hv = squeeze(data.spec_hv(i,:,:));
    end
        
    % check if any data found for this time step - if not, continue with
    % next column
    if data.compress_spec
        if ~any(~isnan(temp(:))) % if any non-nan values found, don't continue
            continue
        end
        
    else
        if all(isnan(temp(:,1)))
            continue
        end
    end
%   temp = squeeze(oldspec(i,:,:));           
%   fig = pcolor_spectra_with_different_velocities(data.velocity,temp,'height',data.range,'range_offsets',data.range_offsets);
%   title(num2str(i));
%   ylim([300,700])
%             
    if i > 1
        vm_prev_col = data.vm(i-1,:)';
    else
        vm_prev_col = NaN(specsize(2),1);
    end

    % 0 = single pol radar, 1 = dual pol radar LDR conf., 2 = dual pol radar STSR mode
    if data.DualPol == 0
        
         [tempspec,tempvel,tempmoments,alias_flag,status_flag] = ...
            dealias_spectra(temp,data.velocity',data.nAvg,data.dr,vm_prev_col,...
            'moment_str','kurt','pnf',1.,'nbins',3,'range_offsets',data.range_offsets,...
            'linear', 'comp_flag', data.compress_spec, 'DualPol', data.DualPol);
    
    elseif data.DualPol == 1
        
        [tempspec,tempvel,tempmoments,alias_flag,status_flag] = ...
            dealias_spectra(temp,data.velocity',data.nAvg,data.dr,vm_prev_col,...
            'moment_str','kurt','pnf',1.,'nbins',3,'range_offsets',data.range_offsets,...
            'linear', 'comp_flag', data.compress_spec, 'DualPol', data.DualPol, temp_hv);
        
    else
        disp('Dealiasing for full polarimetric radar not prgrammed yet - July 2019')
       
    end

%     fig = pcolor_spectra_with_different_velocities(tempvel,tempspec,'height',data.range,'range_offsets',data.range_offsets);
%     hold on;
%     plot(tempmoments.vm,data.range,'kx-')
%     title([num2str(i) ' dealiased'])
%     ylim([300,700])
% 
    % update spectrum
    data.spec(i,:,:) = tempspec;
    data.MinVel(i,:) = tempvel(:,1)';

    % get alias mask and status
    data.Aliasmask(i,:) = alias_flag'; % alias = 1; dealiasing was applied
            
    % status_flag = four bit binary/character that is converted into a real number.
    %   no bit set, everything fine (bin2dec() = 0; or status_flag = '0000'
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
    data.AliasStatus(i,:) = bin2dec(status_flag)';   

    % get moments
    data.Ze(i,:) = tempmoments.Ze';
    data.vm(i,:) = tempmoments.vm';
    data.sigma(i,:) = tempmoments.sigma';
    data.skew(i,:) = tempmoments.skew';
    data.kurt(i,:) = tempmoments.kurt'; 
    
    if ~data.compress_spec
        data.VNoisePow_mean(i,:) = tempmoments.meannoise';
        data.VNoisePow_peak(i,:) = tempmoments.peaknoise';
    end
           
    if data.DualPol > 0
        data.LDR(i,:) = tempmoments.LDR';
        data.Ze_hv(i,:) = tempmoments.Ze_hv';
        data.vm_hv(i,:) = tempmoments.vm_hv';
    end 
    
end % i = 1:numel
        
% compare adjacent columns regarding vm and correct MinVel and vm
%if dealiasing was not performed properly
[data.AliasStatus, data.vm, data.MinVel_Correction] = dealias_spectra_vm_column_qualitiy_check( data.vm, data.range, data.AliasStatus, abs(data.velocity(:,1)), data.MinVel_Correction, data.range_offsets );

% correct MinVel
data.MinVel = data.MinVel + data.MinVel_Correction;
