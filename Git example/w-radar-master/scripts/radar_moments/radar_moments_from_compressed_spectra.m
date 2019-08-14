function output = radar_moments_from_compressed_spectra(spec, velocity, moment_str, linflag)

% input
%   spec: linear compressed doppler spectrum, i.e. noise floor has been
%       removed (height x Nfft)
%   velocity: Doppler velocity array (1 x Nfft)
%   moment_str: indicates highest moment that should be calculated.
%       'Ze','vm','sigma','skew','kurt'
%   linflag == true if spectra are linear
%
% output
%   output: struct containing spectral moments


% ########## preallocate output
s = size(spec);
output.Ze = NaN(s(1),1);
output.vm = NaN(s(1),1);
output.sigma = NaN(s(1),1);
output.skew = NaN(s(1),1);
output.kurt = NaN(s(1),1);

output.peaknoise = NaN(s(1),1);
output.meannoise = NaN(s(1),1);


% ########### check if linear spectrum is provided
if linflag == false % convert into linear regime
    spec = 10.^(spec./10);
end


% ########### set all NaNs in spectra to zero
spec(isnan(spec)) = 0;

    
% ########## calculate moments
output.Ze = nansum(spec,2);

    
if strcmp('vm',moment_str)
    
    output.vm = vm_from_spec(spec,velocity,output.Ze);
    
elseif strcmp('sigma',moment_str)
    
    output.vm = vm_from_spec(spec,velocity,output.Ze);
    output.sigma = sigma_from_spec(spec,velocity,output.vm,output.Ze);
    
elseif strcmp('skew',moment_str)
    
    output.vm = vm_from_spec(spec,velocity,output.Ze);
    output.sigma = sigma_from_spec(spec,velocity,output.vm,output.Ze);
    output.skew = skewness_from_spec(spec,velocity,output.vm,output.sigma,output.Ze);
    
else
    if ~strcmp('kurt',moment_str)
        disp(['moment ' moment_str ' not available. calculated moments until kurtosis']);
    end
    output.vm = vm_from_spec(spec,velocity,output.Ze);
    output.sigma = sigma_from_spec(spec,velocity,output.vm,output.Ze);
    output.skew = skewness_from_spec(spec,velocity,output.vm,output.sigma,output.Ze);
    output.kurt = kurtosis_from_spec(spec,velocity,output.vm,output.sigma,output.Ze);
    
end % if

% set Ze == 0 to NaN
output.Ze(output.Ze == 0) = NaN;

