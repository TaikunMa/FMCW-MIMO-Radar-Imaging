function output = radar_moments_from_compressed_spectra_and_different_chirp_seq(spec, velocity, moment_str, range_offsets, linflag, varargin)

% input
%   spec: linear compressed doppler spectrum, i.e. noise floor has been
%       removed (height x Nfft)
%   velocity: Doppler velocity array (no_seq/height x Nfft)
%   moment_str: indicates highest moment that should be calculated.
%       'Ze','vm','sigma','skew','kurt'
%   linflag == true if spectra are linear
%
% output
%   output: struct containing spectral moments

% ############ check size of velocity array
sv = size(velocity);    

% ########## preallocate output
s = size(spec);
output.Ze = NaN(s(1),1);
output.vm = NaN(s(1),1);
output.sigma = NaN(s(1),1);
output.skew = NaN(s(1),1);
output.kurt = NaN(s(1),1);

output.peaknoise = NaN(s(1),1);
output.meannoise = NaN(s(1),1);


% by default not assuming polarimetry
ix = find(strcmp(varargin,'DualPol'));
if isempty(ix)
    flag_DualPol = 0;
    
else
    
    flag_DualPol = varargin{ix+1};
    
    if flag_DualPol == 1
        spec_hv = varargin{ix+2};
        
        output.Ze_hv = NaN(s(1),1);
        output.vm_hv = NaN(s(1),1);
    end
    
end

    

% ########## adjust range_offsets
if range_offsets(end) < s(1) % then add a value to range_offsets for pracitcal reasons
    range_offsets(end+1) = s(1) + 1;
else
    range_offsets(end) = s(1) + 1;
end

% ########### set all NaNs in spectra to zero
spec(isnan(spec)) = 0;

% ########### get NFFt in each chirp sequence
Nfft = sum(~isnan(velocity),2);


for ii = 1:numel(range_offsets)-1
    
    tempspec = spec(range_offsets(ii):range_offsets(ii+1)-1,1:Nfft(ii));
    
    tempoutput = radar_moments_from_compressed_spectra(tempspec, velocity(ii,1:Nfft(ii)), moment_str, linflag);
    
    if flag_DualPol == 1
        
        tempspec_hv = spec_hv(range_offsets(ii):range_offsets(ii+1)-1,1:Nfft(ii));
    
        tempoutput_hv = radar_moments_from_compressed_spectra(tempspec_hv, velocity(ii,1:Nfft(ii)), 'vm', linflag);
        
        tempoutput.Ze_hv = tempoutput_hv.Ze;
        tempoutput.vm_hv = tempoutput_hv.vm;
        
    end
    
    
    names = fieldnames(tempoutput);
    
    for iii = 1:numel(names)
        
        output.(names{iii})(range_offsets(ii):range_offsets(ii+1)-1,1) = tempoutput.(names{iii});
        
    end % iii
    
end % ii

    
   