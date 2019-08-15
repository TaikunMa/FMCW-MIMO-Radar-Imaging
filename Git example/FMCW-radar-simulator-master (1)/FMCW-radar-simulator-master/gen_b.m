function [ a ] = gen_b( M,Delta,Delta_T,theta,m )
%GEN_A Array response of a uniform linear array
%   Generate the array response a(theta) of a uniform linear array with
%M elements and spacing delta wavelengths to a source coming from direction
%theta degrees
    a = zeros(1,M*m);
	for j=1:m
		for i=1:M
			a((j-1)*M+i) = exp(-2i*pi*(j-1)*Delta_T*sind(theta))*exp(-2i*pi*(i-1)*Delta*sind(theta));
		end
	end
end
