function moments = dealias_spectra_write_tempmoments_to_finalmoments(moments, tempstruct, idx_0, moment_string)

% this function writes moments to output struct depending on what is
% indicated in the main function "dealias_spectra.m"
%
% input:
%   moments: struct containing radar moments specified in "moment"
%   tempstruct: struct containing radar moments specified in "moments" at
%       range bin idx_0
%   idx_0: index of current range bin
%   moment: string specifying the highest moment in tempstruct


% repleaced old code (see below) with a more flexible solution - LP & RG 31.7.2019
fields = fieldnames(tempstruct);

for ff = 1:length(fields)
    moments.(fields{ff})(idx_0) = tempstruct.(fields{ff});
    
end



% if strcmp(moment_string,'vm')
%     
%     moments.Ze(idx_0) = tempstruct.Ze;
%     moments.vm(idx_0) = tempstruct.vm;
%     
% elseif strcmp(moment_string,'sigma')
%     
%     moments.Ze(idx_0) = tempstruct.Ze;
%     moments.vm(idx_0) = tempstruct.vm;
%     moments.sigma(idx_0) = tempstruct.sigma;
%     
% elseif strcmp(moment_string,'skew')
%     
%     moments.Ze(idx_0) = tempstruct.Ze;
%     moments.vm(idx_0) = tempstruct.vm;
%     moments.sigma(idx_0) = tempstruct.sigma;
%     moments.skew(idx_0) = tempstruct.skew;
%     
% else
%     
%     moments.Ze(idx_0) = tempstruct.Ze;
%     moments.vm(idx_0) = tempstruct.vm;
%     moments.sigma(idx_0) = tempstruct.sigma;
%     moments.skew(idx_0) = tempstruct.skew;
%     moments.kurt(idx_0) = tempstruct.kurt;
%     
% end
