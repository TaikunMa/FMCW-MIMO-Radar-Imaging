function cont_mat = spike_filter(spec, six, eix) 
% input:
%   spec: linear Doppler spectra of full column (height x Nfft)
%   six, eix: start and end index for range gate with artifact
%
% output:
%   cont_mat: contaminated bins; if there is no cloud but contamination
%   then all entries are true


% 1) check if there is signal above/below; if not then just set to NaN

ss = size(spec);

% create output matrix
cont_mat = false(ss);

% flag empty range bins
flag = isnan(spec);

for ii = 1:ss(2)

    if all(flag(six-2:six-1, ii)) && all(flag(eix+1:eix+2, ii)) && any(~flag(six:eix, ii)) % check where signal occurs

        % 1) ###################
       
        for rr = six:eix
            
            if flag(rr, ii) == false
                cont_mat(rr,ii) = true;
            end
            
        end

    end
end


end % function