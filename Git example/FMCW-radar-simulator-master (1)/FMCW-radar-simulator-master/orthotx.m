function [out] = orthotx( cfg,ptx,ntx )

		% Phase noise
		k = physconst('Boltzmann');
		T = 300;
		T0 = 290;
		F = 1+T/T0;
		Q = pi*cfg.fc/cfg.bw;
		fcorn = 1e6;
		fm = cfg.fs/cfg.N*cfg.nPulses:cfg.fs/cfg.N*cfg.nPulses:cfg.fs/2;
		phi_PSD = F*k*T./ptx.*(1+(cfg.fc/2/Q./fm).^2).*(1+fcorn./fm);
		phi = 2i*pi*randn(1,cfg.N/2/cfg.nPulses);
		Y = phi.*(phi_PSD);
		Y = [Y fliplr(Y)];
		phi = abs(ifft(Y*cfg.fs*cfg.N/cfg.nPulses,[],2));
        phi = repmat(phi,1,cfg.nPulses);
        % Orthogonal waveforms for transmitters
		x = exp(2i*pi*(cfg.bw/2/cfg.ts.*cfg.t).*cfg.t+phi);
        delay = cfg.fs*cfg.tmax;
        out = zeros(ntx,cfg.N);
        for i=1:ntx
            out(i,:)=[x(end-(i-1)*delay+1:end),x(1:end-(i-1)*delay)]; 
        end
end
