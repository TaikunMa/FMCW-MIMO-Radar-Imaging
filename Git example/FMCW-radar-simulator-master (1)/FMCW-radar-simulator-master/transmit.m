function [xu,xd] = transmit( fs,fc,bw,ts,t,pt )

		N = length(t);
		
		% Phase noise
		k = physconst('Boltzmann');
		F = 10^(6/10);
		T = 290;
		Q = pi*fc/bw;
		fcorn = 1e6;
		fm = fs/N:fs/N:fs/2;
		phi_PSD = F*k*T/pt*(1+(fc/2/Q./fm).^2).*(1+fcorn./fm);
		phi = 2i*pi*randn(1,N/2);
		Y = phi.*(phi_PSD);
		Y = [Y fliplr(Y)];
		phi = abs(ifft(Y*fs*N));
		
		% Receiver noise added in propagate.m

		xu = exp(2i*pi*(bw/2/ts.*t).*t+phi);
		xd = exp(-2i*pi*(bw/2/ts.*t).*t+phi);

end
