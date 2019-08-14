function skewness = skewness_from_spec(spec,velocity,vm,sigma,Ze)

ss = size(spec);
sv = size(velocity);

if sum(sv==ss) == 2 
    skewness = ( nansum( spec.*(velocity-vm).^3, 2 ) )./( Ze.*sigma.^3 );
else
    skewness = ( nansum( spec.*(repmat(velocity, ss(1),1)-repmat(vm, 1, sv(2))).^3, 2 ) )./( Ze.*sigma.^3 );      
end % if

end % function