function sigma = sigma_from_spec(spec, velocity, vm, Ze)

ss = size(spec);
sv = size(velocity);

if sum(sv==ss) == 2 
    sigma = sqrt( nansum(spec.*(velocity-vm).^2, 2)./Ze );
else
    sigma = sqrt( nansum(spec.*(repmat(velocity, ss(1),1)-repmat(vm, 1, sv(2))).^2, 2)./Ze );
end % if    

end % function
