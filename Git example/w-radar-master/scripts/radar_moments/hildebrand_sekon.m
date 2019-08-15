function output = hildebrand_sekon(spec,nAvg,varargin)

 % spectrum: input spectrum in linear power, can be two dimensional:
 % increasing row = increasing range; increasing column = increasing
 % doppler velocity
 % nAvg: number of spectral averages
 % varargin: input flag - if varargin contains the character 'mean', then
 %      mean noise floor is returned, too, otherwise, peak noise only is returned
 % peak_noise: peak noise also always available here
 % signal_detected: signal power detected

  
% make sure that variables are of class double
spec = double(spec);
nAvg = double(nAvg);

s = size(spec);
savg = size(nAvg);

N = sum(~isnan(spec),2);

if savg(1) > savg(2)
    nAvg = nAvg';
    savg = size(savg);
end
    
if savg(2) == 1 && s(1) > 1 % then several range gates with same nAvg are provided
    nAvg = ones(1,s(1))*nAvg;
end


% allocate
output.peaknoise = NaN(s(1),1);
output.meannoise = NaN(s(1),1);

sortSpec = sort(spec,2);
sumsum = cumsum(sortSpec,2).^2;
sumsquared = cumsum(sortSpec.^2,2);


for i = 1:s(1)
    
    if N(i) == 0
        continue
    end
    npts = 1:N(i);
    
    a = find( nAvg(i)*(npts.*sumsquared(i,1:N(i))-sumsum(i,1:N(i))) < sumsum(i,1:N(i)), 1, 'last' );
    
    if isempty(a)
       a = 1;
    end

    if a < 10

        output.peaknoise(i,1) = max(spec(i,1:N(i)));
        output.signal_detected(i,1) = sortSpec(i,N(i)) > output.peaknoise(i);
        if any(strcmp('mean',varargin))
            output.meannoise(i,1) = mean(spec(i,1:N(i)));
        end % if
    
    else % if
        
        output.peaknoise(i,1) = sortSpec(i,a);
        output.signal_detected(i,1) = sortSpec(i,N(i)) > output.peaknoise(i); % signal detected
        if any(strcmp('mean',varargin))
            output.meannoise(i,1) = mean(sortSpec(i,1:a));
        end % if
        
    end % if


end % for

end% function
