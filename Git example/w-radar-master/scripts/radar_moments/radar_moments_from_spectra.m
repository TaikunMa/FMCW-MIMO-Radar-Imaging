function output = radar_moments_from_spectra(spec, velocity, nAvg, varargin)

% input
%   spec: doppler spectrum (height x Nfft)
%   velocity: velocity array (1 x Nfft)
%   nAvg: number of spectral averages
%   varargin:
%           the highest moment to be calculated, if nothing specified
%               all are calculated; allowed are:
%               'skew', 'kurt'
%           if varargin contains 'linear' than linear spectrum
%               is expected
%           if N > 1, varargin may contain 'range_offsets' followed by an array containing integers, i.e. indexes where new chirp
%               sequence starts
%           can also contain 'pnf' or 'mnf' followed by a float number that gives
%           the multiple of the peak/mean noise that must be exceeded in a
%           spectral bin to be considered to be significant, default is mnf
%           = 1;
%           can contain number of consecutiv bins: 'nbins',nbins; default =
%           3;
%           can contain 'noise' followed by a struct containing the mean
%           and peak noise for the full column
%
% output
%   output: struct containing moments



% ########## check sizes
sv = size(velocity);
ss = size(spec);

% ########## preallocate output
output.Ze = NaN(ss(1),1);
output.vm = NaN(ss(1),1);
output.sigma = NaN(ss(1),1);
output.skew = NaN(ss(1),1);
output.kurt = NaN(ss(1),1);

output.peaknoise = NaN(ss(1),1);
output.meannoise = NaN(ss(1),1);


% ######### check if nosie is provided
if any(strcmp(varargin,'noise'))
    tempnoise = varargin{ find(strcmp(varargin,'noise'), 1) + 1 };
    output.meannoise = tempnoise.meannoise;
    output.peaknoise = tempnoise.peaknoise;
else
    tempnoise = hildebrand_sekon(spec,nAvg,'mean');
    output.meannoise = tempnoise.meannoise;
    output.peaknoise = tempnoise.peaknoise;
end

% ########### check if linear spectrum is provided
if ~any(strcmp(varargin,'linear')) % convert into linear regime
    spec = 10.^(spec./10);
    if noiseflag == true
        output.meannoise = 10.^(output.meannoise/10);
        output.peaknoise = 10.^(output.peaknoise/10);
    end
end


% ########## minimum number of consective bins
if any(strcmp(varargin,'nbins'))
    X = varargin{ find(strcmp(varargin,'nbins'), 1) + 1 };
else
    X = 3;
end


% ########### check if peak noise faktor was provided
idx_pnf = find(strcmp(varargin,'pnf'), 1) + 1;
idx_mnf = find(strcmp(varargin,'mnf'), 1) + 1;
if isempty(idx_pnf) && isempty(idx_mnf)
    pnf = 1.0;
elseif ~isempty(idx_pnf)
    pnf = varargin{idx_pnf};
else
    mnf = varargin{idx_mnf};
end

% ########## get moment to be calculated
if ~any(strcmp(varargin,'moment_str'))
    moment_str = 'kurt';    
else
    moment_str = varargin{ find(strcmp(varargin,'moment_str'), 1) + 1 };
end

% ########### get significant signal
for i = 1:ss(1)
    idxnew = false(1,ss(2)); %indicates location of significant signal
    
    
    % find all spectral entries larger than nf*noisetype
    if exist('pnf','var')
        idx = spec(i,:) > pnf*output.peaknoise(i);
    else
        idx = spec(i,:) > mnf*output.meannoise(i);
    end
    
    
    if sum(idx) < X % then there is no signal
        spec(i,:) = NaN;
        continue
    end
    
    % determine blocks of consecutive bins
    [block_start, block_end] = radar_moments_get_blocks_of_signal(idx,sv);
    
    if isnan(block_start)
        spec(i,:) = NaN;
        continue
    end
    
    % determine size of these blocks
    blocksizes = block_end - block_start + 1;
    
    % consider only blocks with consecutive bins larger than X-1
    idx_blocks = blocksizes >= X;
    
    if ~any(idx_blocks) % then no signal found
        spec(i,:) = NaN;
        continue
    end
    
    block_start = block_start(idx_blocks);
    block_end = block_end(idx_blocks);
    
    % determine signal above mean noise for all blocks left
    for ii = 1:numel(block_start)
        
        % first entry aboce mean noise
        startidx = find( spec(i, 1:block_start(ii)) < output.meannoise(i), 1, 'last') + 1;
        % last entry above mean noise
        endidx = find( spec(i, block_end(ii):end) < output.meannoise(i), 1, 'first') + block_end(ii) - 2;
        
        if isempty(startidx) % then first entry is still above mean noise -> aliasing likely
            startidx = 1;
        end
        if isempty(endidx) % then last entry is still above mean noise -> aliasing likely
            endidx = ss(2);
        end
        
        idxnew(startidx:endidx) = true;      
        
    end % for ii
    
    
    if ~any(idxnew) % now signal was detected
        spec(i,:) = NaN;
        continue
    end
            
    % now set set all spectral entries that are not in idxnew to zero
    spec(i,~idxnew) = 0;
    % substract the mean noise level
    spec(i,idxnew) = spec(i,idxnew) - output.meannoise(i);
    spec(i,spec(i,:)<0) = 0;
    
%     if any(idxnew) % then there is signal
%         
%         tempstruct = radar_moments_call_moments(velocity, spec(i,:), moment_str);
%         output = dealias_spectra_write_tempmoments_to_finalmoments(output, tempstruct, i, moment_str);
%         
%         % check for non physical signals: flag == true -> spectrum was
%         % modified
%         [spec(i,:), flag] = radar_moments_check_significant_peaks(velocity, spec(i,:), idxnew, output.skew(i));
%         
%         if flag == true % recalculate moments
%             tempstruct = radar_moments_call_moments(velocity, spec(i,:), moment_str);
%             output = dealias_spectra_write_tempmoments_to_finalmoments(output, tempstruct, i, moment_str);
%         end
%         
%     end
    
    
end % i

tempstruct = radar_moments_call_moments(velocity, spec, moment_str);
output = dealias_spectra_write_tempmoments_to_finalmoments(output, tempstruct, 1:ss(1), moment_str);



