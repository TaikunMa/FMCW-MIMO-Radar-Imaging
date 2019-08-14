function [ out,sigma_n ] = propagate( cfg,tx,rx,env )
%TRANSMIT output reflected wave from all (point) scatterers to all sensors
    
    r = zeros(rx.nrx,cfg.N);
	out = zeros(rx.nrx,cfg.N);
	for i=1:env.nTargets
		r_n = zeros(tx.ntx*tx.mtx,cfg.N);
		ar = gen_a(rx.nrx,rx.dr/cfg.lambda,rx.theta(i));
		at = gen_b(tx.ntx,tx.dt/cfg.lambda,tx.Dt/cfg.lambda,tx.theta(i),tx.mtx);
		A = ar.'*at;
        range1 = sqrt((env.targetPos(i,1)-tx.pos(1,1))^2+(env.targetPos(i,2)-tx.pos(1,2))^2);	%from tx to target
        range0 = sqrt((env.targetPos(i,1)-rx.pos(1,1))^2+(env.targetPos(i,2)-rx.pos(1,2))^2);	%from target to rx
        tau0 = (range0+range1)/cfg.c;
        r_t = range1+2*env.targetVel(i).*cfg.t+range0;
		L = 0.1;
        gt = 0.6*(pi*L/cfg.lambda)^2;
		gr = 0.6*(pi*L/cfg.lambda)^2;
        pr = repmat(tx.pow,1,cfg.N).*gt*gr*env.targetRCS(i)*cfg.lambda^2./(4*pi)^3./repmat(r_t,tx.ntx*tx.mtx,1).^4;
        phi_f = repmat(exp(-4i*pi*env.targetVel(i).*r_t/cfg.lambda),tx.mtx*tx.ntx,1);
        foo = reshape(repmat(0:1:(cfg.nPulses-1),cfg.N/cfg.nPulses,1),1,cfg.N);
        phi_s = repmat(exp(-4i*pi*env.targetVel(i)*cfg.ts*foo/cfg.lambda),tx.mtx*tx.ntx,1);
		r_n(:,floor(tau0*cfg.fs)+1:end) = tx.waveform(:,1:end-floor(tau0*cfg.fs));
        r_n(:,1:floor(tau0*cfg.fs)) = tx.waveform(:,end-floor(tau0*cfg.fs)+1:end);
        r_n = r_n.*phi_f.*phi_s;
        r = r + (A*(pr.*r_n));
	end
	for i=1:rx.nrx
		T = 290;
		noiseBW = cfg.fs;
		sigma_n = noisepow(noiseBW,10,T);
		H = comm.ThermalNoise('NoiseTemperature',T/20,'SampleRate',cfg.fs/8);
		out(i,:) = step(H,r(i,:).').';
	end
	out = out + (env.clutter).';
end
