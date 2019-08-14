function [data] = moments_retrieval(data)

specsize = size(data.spec);

%Retrieval of moments
% preallocate moments
data.Ze = NaN(specsize(1:2));
data.vm =  NaN(specsize(1:2));
data.sigma =  NaN(specsize(1:2));
data.skew =  NaN(specsize(1:2));
data.kurt =  NaN(specsize(1:2));
if data.CompEna == 0
    data.VNoisePow_mean = NaN(specsize(1:2));
    data.VNoisePow_peak = NaN(specsize(1:2));
end

if isfield(data,'DualPol')
    depol_case = data.DualPol;
    switch data.DualPol
        case 1            
            disp('LDR-mode available')            
            data.Ze_hv = NaN(specsize(1:2));
            if data.CompEna == 0
                data.HNoisePow_mean = NaN(specsize(1:2));
                data.HNoisePow_peak = NaN(specsize(1:2));
            end            
        case 2
            disp('STSR-mode available.')
            disp('Products from STSR-mode not derived yet.')            
    end            
else
    disp('DualPol field not found. Depolarization products will not be process.')
end

% ########## check if range_offsets are provided 
% check where the chirp sequence changes
if isfield(data,'range_offsets')    
    range_offsets = data.range_offsets;
    % Adjust range_offsets
    if range_offsets(end) < specsize(2) % then add a value to range_offsets for practical reasons
        range_offsets(end+1) = specsize(2) + 1;
    else
        range_offsets(end) = specsize(2) + 1;
    end
else       
   range_offsets = 1:(specsize(2)+1);
end

% ############ check size of arrays
ss = size(squeeze(data.spec(1,:,:)));
sv = size(data.velocity);
velocity = data.velocity;
if ne(ss(1),sv(1)) && ne(ss(2),sv(2)) % then there is a velocity array for each chrip sequence    
    if sv(1) > sv(2)        
        velocity = data.velocity';
    end
end % else each spectrum has its own velocity array
for i = 1:numel(data.time)            
    %Co-pol
    temp = squeeze(data.spec(i,:,:));            


    if data.CompEna == 0                
        temp = noise_substraction(temp, velocity, nAvg, noise, 1, range_offsets, moment_str, mnf, pnf, bins);
    end    
        
    tempmoments = radar_chirps(temp, velocity, range_offsets);  
    
        % get moments
    data.Ze(i,:) = tempmoments.Ze';
    data.vm(i,:) = tempmoments.vm';
    data.sigma(i,:) = tempmoments.sigma';
    data.skew(i,:) = tempmoments.skew';
    data.kurt(i,:) = tempmoments.kurt';
    if data.CompEna == 0
        data.VNoisePow_mean(i,:) = tempmoments.meannoise';
        data.VNoisePow_peak(i,:) = tempmoments.peaknoise';
    end
    
    if depol_case==1
        %Co-pol
        temp = squeeze(data.spec_hv(i,:,:));            
        
        if data.CompEna == 0                
            temp = noise_substraction(temp, velocity, nAvg, noise, 1, range_offsets, moment_str, mnf, pnf, bins);
        end    

        tempmoments = radar_chirps(temp, velocity, range_offsets);       
            % get moments
        data.Ze_hv(i,:) = tempmoments.Ze';
        data.vm_hv(i,:) = tempmoments.vm';
%         data.hsigma(i,:) = tempmoments.sigma';
%         data.hskew(i,:) = tempmoments.skew';
%         data.hkurt(i,:) = tempmoments.kurt';
        if data.CompEna == 0
            data.HNoisePow_mean(i,:) = tempmoments.meannoise';
            data.HNoisePow_peak(i,:) = tempmoments.peaknoise';
        end        
    end    
end % i = 1:numel

%LDR module
if depol_case==1
    %LDR Retrieval
    data.LDR = data.Ze_hv./data.Ze;
    
    %Retrieval of spectral co-cross-channel correlation coefficient
    % calculate moments
    covRe = squeeze(nansum(data.spec_covRe,3));
    covIm = squeeze(nansum(data.spec_covIm,3));    
    data.xcorr = sqrt(covRe.^2 + covIm.^2)./(data.Ze_hv - data.Ze);     
    data.difphase = covRe./covIm;
end
    











