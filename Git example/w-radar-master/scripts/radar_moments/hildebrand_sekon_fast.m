function output = hildebrand_sekon_test(spec,nAvg,range_offsets,N,varargin)

 % spectrum: input spectrum in linear power, can be two dimensional:
 % increasing row = increasing range; increasing column = increasing
 % doppler velocity
 % nAvg: number of spectral averages
 % range_offsets:
 % N: number of spectral averages
 % varargin: input flag - if varargin contains the character 'mean', then
 %      mean noise floor is returned, too, otherwise, peak noise only is returned

 % peak_noise: peak noise also always available here
 % signal_detected: signal power detected

  
% make sure that variables are of class double
spec = double(spec);
nAvg = double(nAvg);

s = size(spec);
savg = size(nAvg);

if savg(1) > savg(2)
    nAvg = nAvg';
    savg = size(savg);
end
    
signal_flag = ~isnan(spec(:,1));

% add range offset for computing
range_offsets(end+1) = s(1);

% allocate
if isempty(varargin)
    meannoise_flag = false;
else
    meannoise_flag = true;
    output.meannoise = NaN(s(1),1);
end

output.peaknoise = NaN(s(1),1);
output.signal_detected = false(s(1),1);

for ii = 1:savg(2)
    
    npts = 1:N(ii);
    r_idx = range_offsets(ii):range_offsets(ii+1);
    
    sortSpec = sort(spec(r_idx,npts),2);
    sumsum = cumsum(sortSpec,2).^2;
    sumsquared = cumsum(sortSpec.^2,2);


    for iii = 1:numel(r_idx)

        if signal_flag(r_idx(iii)) == false
            continue;
        end
        
        a = find( nAvg(ii)*(npts.*sumsquared(iii,npts)-sumsum(iii,npts)) < sumsum(iii,npts), 1, 'last' );

        if isempty(a)
           a = 1;
        end

        if a < 10

            output.peaknoise(r_idx(iii),1) = max(spec(r_idx(iii),npts));
            output.signal_detected(iii,1) = sortSpec(iii,N(ii)) > output.peaknoise(r_idx(iii));
            if meannoise_flag == true
                output.meannoise(r_idx(iii),1) = mean(spec(r_idx(iii),npts));
            end % if

        else % if

            output.peaknoise(r_idx(iii),1) = sortSpec(iii,a);
            output.signal_detected(r_idx(iii),1) = sortSpec(iii,N(ii)) > output.peaknoise(r_idx(iii)); % signal detected
            
            if meannoise_flag == true
                output.meannoise(r_idx(iii),1) = mean(sortSpec(iii,1:a));
            end % if

        end % if


    end % for iii

end % for ii

end% function