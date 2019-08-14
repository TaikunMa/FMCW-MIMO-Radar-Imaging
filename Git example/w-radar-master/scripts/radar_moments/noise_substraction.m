function  spec = noise_substraction(spec, velocity, nAvg, noise, linflag,range_offsets,moment_str,mnf, pnf, bins, varargin)

% input
%   spec: doppler spectra (height x Nfft)
%   velocity: doppler vel array (no_seq x Nfft)
%   nAvg: number of spectral averages
%   varargin
%       - 'moment_str', moment_string
%           moment_string = 'Ze', 'vm', 'sigma', skew' or 'kurt' (default
%           'kurt')
%       - 'range_offsets', range_offsets: indexes where chirp sequences start
%       - 'compressed' then spectra do not contain noise floor
%       - 'linear' then linear spectra are provided
%       - 'noise', noise
%           spectra noise floor
%       - 'nbins', nbins (default nbins = 3)
%           number of consecutive bins that must exceed threshold to
%           count as significant signal
%       - 'pnf' or 'mnf', nf (default 'pnf',1)
%           peak or mean noise factor that the signal must exceed to count
%           as signficant


% ########## check sizes
sv = size(velocity);    
ss = size(spec);

% ######### check if noise is provided
noiseflag = any(strcmp(varargin,'noise'));
if noiseflag == true
    inputnoise = varargin{ find(strcmp(varargin,'noise'), 1) + 1 };   
end

% ########### check if linear spectrum is provided
if ~linflag % convert into linear regime
    spec = 10.^(spec./10);
    if noiseflag == true   
        inputnoise.meannoise = 10.^(inputnoise.meannoise/10);
        inputnoise.peaknoise = 10.^(inputnoise.peaknoise/10);
    end
end

% ########## minimum number of consective bins
if ~isempty(nbins)
    X = nbins;
else
    X = 3;
end

% ########### check if peak noise faktor was provided
if isempty(mnf) && isempty(pnf)
    pnf = 1.0;
end

% get Nfft
Nfft = sum(~isnan(velocity),2);

for i = 1:numel(range_offsets)-1    
    % get range indexes
    r_idx = range_offsets(i):range_offsets(i+1)-1;
    
    % get mean and peak noise
    if noiseflag == false
        noise = hildebrand_sekon(spec(r_idx,1:Nfft(i)),nAvg(i),'mean');
        output.meannoise(r_idx,1) = noise.meannoise;
        output.peaknoise(r_idx,1) = noise.peaknoise;
    else
        output.meannoise(r_idx,1) = inputnoise.meannoise(r_idx,1);
        output.peaknoise(r_idx,1) = inputnoise.peaknoise(r_idx,1);
    end       
   
    for ii = 1:numel(r_idx)        
        idxnew = false(1,Nfft(i));  %indicates location of significant signal
         
        % find all spectral entries larger than pnf*peaknoise
        if exist('pnf','var')
            idx = spec(r_idx(ii),1:Nfft(i)) > pnf*output.peaknoise(r_idx(ii),1);
        else
            idx = spec(r_idx(ii),1:Nfft(i)) > mnf*output.meannoise(r_idx(ii),1);
        end
        
        if sum(idx) < X % then there is no signal
            spec(r_idx(ii),:) = NaN;
            continue
        end
        
        % determine blocks of consecutive bins
        [block_start, block_end] = radar_moments_get_blocks_of_signal(idx,[1,Nfft(i)]);
        
        if all(isnan(block_start))
            spec(r_idx(ii),:) = NaN;
            continue
        end
        
        % determine size of these blocks
        blocksizes = block_end - block_start + 1;
        
        % consider only blocks with consecutive bins larger than X-1
        idx_blocks = blocksizes >= X;
        
        if ~any(idx_blocks) % then no signal found
            spec(r_idx(ii),:) = NaN;
            continue
        end
        
        block_start = block_start(idx_blocks);
        block_end = block_end(idx_blocks);
        
        % determine signal above mean noise for all blocks left
        for iii = 1:numel(block_start)
            
            % first entry aboce mean noise
            startidx = find( spec(r_idx(ii), 1:block_start(iii)) < output.meannoise(r_idx(ii)), 1, 'last') + 1;
            % last entry above mean noise
            endidx = find( spec(r_idx(ii), block_end(iii):Nfft(i)) < output.meannoise(r_idx(ii)), 1, 'first') + block_end(iii) - 2;
            
            if isempty(startidx) % then first entry is still above mean noise -> aliasing likely
                startidx = 1;
            end
            if isempty(endidx) % then last entry is still above mean noise -> aliasing likely
                endidx = Nfft(i);
            end
            
            idxnew(startidx:endidx) = true;
            
        end % for ii
        
        if ~any(idxnew) % now signal was detected
            spec(r_idx(ii),:) = NaN;
            continue
        end
    
        % now set set all spectral entries that are not in idxnew to zero
        spec(r_idx(ii),~idxnew) = 0;
        % substract the mean noise level
        spec(r_idx(ii),idxnew) = spec(r_idx(ii),idxnew) - output.meannoise(r_idx(ii),1);
        spec(r_idx(ii),spec(r_idx(ii),1:Nfft(i))<0) = 0;                        
    end    
end % i
