function vm = vm_from_spec(spec,velocity,Ze)

% this function expects spectra in dB/m of the size [numel(velocity),1]
% velocity contains doppler velocity bins

ss = size(spec);
sv = size(velocity);

if sum(sv==ss) == 2 
    vm = nansum(spec.*velocity,2)./Ze;
else        
    vm = nansum(spec.*repmat(velocity,ss(1),1),2)./Ze;
end        

end % function