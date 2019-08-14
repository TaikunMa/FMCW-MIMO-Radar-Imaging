function kurt = kurtosis_from_spec(spec,velocity,vm,sigma,Ze)

ss = size(spec);
sv = size(velocity);

if sum(sv==ss) == 2 
    kurt = ( nansum( spec.*(velocity-vm).^4, 2 ) )/( Ze*sigma^4 );
else
    kurt = ( nansum( spec.*(repmat(velocity, ss(1),1)-repmat(vm, 1, sv(2))).^4, 2 ) )./( Ze.*sigma.^4 );    
end % if

end % function