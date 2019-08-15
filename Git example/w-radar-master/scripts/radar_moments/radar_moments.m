function output = radar_moments(spec,velocity,nAvg,varargin)

% input
%   spec: Doppler spectra (height x Nfft)
%   velocity: velocity array(s) (no_seq x Nfft)
%   nAvg: numver of spectral averages (no_seq x 1) or (height x 1)
%   varargin:
%       - 'moment_str', moment_string
%           moment_string = 'Ze', 'vm', 'sigma', skew' or 'kurt'
%       - 'range_offsets', range_offsets: indexes where chirp sequences start
%       - 'compressed' then spectra do not contain noise floor
%       - 'linear' then linear spectra are provided
%       - further variables for subfunctions, see subfunctions called with
%           varargin{:}
%       
% output
%   output: struct containing moments of spectra


% ############ check size of arrays
ss = size(spec);
sv = size(velocity);

if ne(ss(1),sv(1)) && ne(ss(2),sv(2)) % then there is a velocity array for each chrip sequence
    if sv(1) > sv(2)
        velocity = velocity';
    end
end % else each spectrum has its own velocity array


% ########## check which moments are to be calculated
if ~any(strcmp(varargin,'moment_str'))
    moment_str = 'kurt';
else
    moment_str = varargin{find(strcmp(varargin,'moment_str'), 1) + 1};
end


% ########## check if range_offsets are provided
idx_range_offsets = find(strcmp(varargin,'range_offsets'), 1) + 1;


% ########## check if spectra are compressed
ix = find(strcmp(varargin,'compressed'));
if isempty(ix)
    idx_compress = 0;
    
else
    idx_compress = varargin{ix+1};
end
    

% ######### check units of spectra
linflag = true;
if ~any(strcmp(varargin,'linear'))
    linflag = false;
end

% by default not assuming polarimetry
ix = find(strcmp(varargin,'DualPol'));
if isempty(ix)
    flag_DualPol = 0;
    
else
    
    flag_DualPol = varargin{ix+1};
    
    if flag_DualPol == 1
        spec_hv = varargin{ix+2};
    end
    
end


% ######### calculate radar moments
if idx_compress == true && isempty(idx_range_offsets)
    
    output = radar_moments_from_compressed_spectra(spec, velocity, moment_str, linflag);

    if flag_DualPol == 1
        tempoutput = radar_moments_from_compressed_spectra(spec_hv, velocity, 'vm', linflag);
        
        output.Ze_hv = tempoutput.Ze;
        output.vm_hv = tempoutput.vm;
        
    end

elseif idx_compress == true && ~isempty(idx_range_offsets)
    
    switch flag_DualPol
        
        case 0
            output = radar_moments_from_compressed_spectra_and_different_chirp_seq(spec, velocity, moment_str, varargin{idx_range_offsets}, linflag);
        case 1
            output = radar_moments_from_compressed_spectra_and_different_chirp_seq(spec, velocity, moment_str, varargin{idx_range_offsets}, linflag, 'DualPol',flag_DualPol, spec_hv);
        case 2 
            disp('not done yet')
    end

    
elseif idx_compress == false && isempty(idx_range_offsets)
    
    output = radar_moments_from_spectra(spec, velocity, nAvg, varargin{:});
    
    
    if flag_DualPol == 1
        tempoutput =  radar_moments_from_spectra(spec_hv, velocity, nAvg, varargin{:});
        
        output.Ze_hv = tempoutput.Ze;
        output.vm_hv = tempoutput.vm;
        
    end
    
elseif idx_compress == false && ~isempty(idx_range_offsets)
    
    output = radar_moments_from_spectra_and_different_chrip_seq(spec, velocity, nAvg, varargin{:});    
    
    if flag_DualPol == 1
        
        tempvarargin = varargin;
        ix = find(strcmp(varargin, 'moment_str'));
        tempvarargin{ix + 1} = 'vm';
        tempoutput =  radar_moments_from_spectra_and_different_chrip_seq(spec_hv, velocity, nAvg, tempvarargin{:});    
        
        output.Ze_hv = tempoutput.Ze;
        output.vm_hv = tempoutput.vm;
        
    end
    
end

% set Ze == 0 to NaN
output.Ze(output.Ze == 0) = NaN;

if flag_DualPol > 0 
    output.Ze_hv(output.Ze_hv == 0) = NaN;
    
    % compute linear depolarisation ratio
    output.LDR = output.Ze_hv ./ output.Ze;
end

