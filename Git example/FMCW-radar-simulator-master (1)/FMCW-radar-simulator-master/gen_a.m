function [ a ] = gen_a( M,Delta,theta )
%GEN_A Array response of a uniform linear array
%   Generate the array response a(theta) of a uniform linear array with
%M elements and spacing delta wavelengths to a source coming from direction
%theta degrees
    a = zeros(1,M);
    for i=1:M
        a(i) = exp(-2i*pi*(i-1)*Delta*sind(theta));
    end
end
