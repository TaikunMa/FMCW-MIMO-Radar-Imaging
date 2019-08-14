function output = radar_moments_call_moments(velocity, spec, moment_str, varargin)
% this function calls functions to calculate moments, depending string
% indicated in moment_str

% input:
%   velocity array
%   linear spectrum
%   moment_str: string indicating highest moment to be calculated
%   varargin: struct that can contain preallocated output with additional
%   variables

if ~isempty(varargin)
    output = varargin{1};
end

% ########## calculate moments
output.Ze = nansum(spec,2);

if strcmp('Ze',moment_str)
    
    return
    
elseif strcmp('vm',moment_str)
    
    output.vm = vm_from_spec(spec, velocity, output.Ze);
    
elseif strcmp('sigma',moment_str)
    
    output.vm = vm_from_spec(spec, velocity, output.Ze);
    output.sigma = sigma_from_spec(spec, velocity, output.vm, output.Ze);

elseif strcmp('skew',moment_str)
    
    output.vm = vm_from_spec(spec, velocity, output.Ze);
    output.sigma = sigma_from_spec(spec, velocity, output.vm, output.Ze);
    output.skew = skewness_from_spec(spec, velocity, output.vm, output.sigma, output.Ze);
    
else
    
    output.vm = vm_from_spec(spec, velocity, output.Ze);
    output.sigma = sigma_from_spec(spec, velocity, output.vm, output.Ze);
    output.skew = skewness_from_spec(spec, velocity, output.vm, output.sigma, output.Ze);
    output.kurt = kurtosis_from_spec(spec, velocity, output.vm, output.sigma, output.Ze);
    
end % if
