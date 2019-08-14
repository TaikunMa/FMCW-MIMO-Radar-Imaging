clear; close all;
fprintf('\nInitialising the environment...') ;
cfg.fc = 77e9;
cfg.c = physconst('LightSpeed');
cfg.lambda = cfg.c/cfg.fc;
cfg.bw = 2^30;
cfg.ts = 2^-16;
cfg.mu = cfg.bw/cfg.ts;
cfg.delta_R = cfg.c/2/cfg.bw;
cfg.Rmax = 250;
cfg.Rmax = 2^nextpow2(cfg.Rmax/cfg.delta_R)*cfg.delta_R;
cfg.tmax = 2*cfg.Rmax/cfg.c;
cfg.fs = 2*cfg.bw;
cfg.N_dec = round(cfg.Rmax/cfg.delta_R);
cfg.nPulses = 128;
cfg.t = repmat(0:1/cfg.fs:cfg.ts-1/cfg.fs,1,cfg.nPulses);
cfg.N = length(cfg.t);
cfg.f_dec = cfg.N/cfg.nPulses/cfg.N_dec;
tx.dt = cfg.lambda/2;
tx.mtx = 2;
tx.ntx = 3;
rx.nrx = 4;
rx.dr = tx.ntx*tx.dt; 
tx.Dt = rx.nrx*rx.dr;
fprintf('DONE');

% Receivers
fprintf('\nInitialising receivers...') ;
rx.pos = zeros(rx.nrx,2);
rx.pos(:,1) = 50 + [-(rx.nrx-1)/2:1:(rx.nrx-1)/2]'.*rx.dr;		% x
rx.pos(:,2) = ones(rx.nrx,1);                                   % y
fprintf('DONE');

% Transmitters
fprintf('\nInitialising transmitters...');
tx.pos = zeros(tx.ntx*tx.mtx,3);
%located lambda/2 left of rx array
tx.pos(1:tx.ntx,1) = rx.pos(1,1) + [-(tx.ntx-0.5):1:-0.5]'*tx.dt;		% x
for i=1:tx.mtx-1
	tx.pos(i*tx.ntx+1:(i+1)*tx.ntx) = tx.pos((i-1)*tx.ntx+1,1) + tx.Dt + [0:tx.ntx-1]'*tx.dt;
end
tx.pos(:,2) = ones(tx.ntx*tx.mtx,1);									% y
tx.pow = 10*ones(tx.ntx*tx.mtx,1);                                      % Power (W)
fprintf('DONE');

% targets
fprintf('\nPlacing targets...');
env.nTargets = 2;
env.targetPos = zeros(env.nTargets,2);
% target positions (x,y)
env.targetPos(1,:) = [70 80];
env.targetPos(2,:) = [30 60];
%targets(3,1:2) = [21 50];
%targets(4,1:2) = [10 50];
rx.theta = atand((env.targetPos(:,1)-repmat(rx.pos(1,1),env.nTargets,1))./(env.targetPos(:,2)-repmat(rx.pos(1,2),env.nTargets,1)));
tx.theta = atand((env.targetPos(:,1)-repmat(tx.pos(1,1),env.nTargets,1))./(env.targetPos(:,2)-repmat(tx.pos(1,2),env.nTargets,1)));
env.targetRange = sqrt(sum((repmat(rx.pos(1,:),env.nTargets,1)-env.targetPos).^2,2));
% target velocities (radial)
env.targetVel(1) = 24*1000/3600;
env.targetVel(2) = 72*1000/3600;
%targets(3,3) = 64*1000/3600;
% target RCS
env.targetRCS = 100*ones(env.nTargets,1);
fprintf('DONE');

files = ls;
% Uncomment for windows
if(sum(strcmp(cellstr(files),'filter.mat'))==0)
   fprintf('\nDesigning filters...');
   % Filter parameters
   rx.fstop = cfg.Rmax*cfg.bw/cfg.c/cfg.ts;
   rx.fpass = rx.fstop/1.2;
   rx.fd = fdesign.lowpass(2*fpass/fs,2*fstop/fs,1,60);
   hd = design(fd,'equiripple');
   fprintf('DONE');
% Uncomment for linux
% if(isempty(strfind(files,'filter.mat')))
%     fprintf('\nDesigning filters...');
%     % Filter parameters
%     rx.fstop = cfg.Rmax*cfg.bw/cfg.c/cfg.ts;
%     rx.fpass = rx.fstop/1.2;
%     rx.fd = fdesign.lowpass(2*rx.fpass/fs,2*rx.fstop/fs,1,60);
%     hd = design(fd,'equiripple');
%     fprintf('DONE');
else
    fprintf('\nLoading filters...');
    filter = load('filter.mat');
    rx.fd = filter.fd;
    rx.fpass = rx.fd.Fpass;
    rx.fstop = rx.fd.Fstop;
    rx.hd = filter.hd;
    clear filter;
    fprintf('DONE');
end
% Uncomment for windows
if(sum(strcmp(cellstr(files),'clutter.mat'))==0)
    fprintf('\nModelling clutter...');
    arr = phased.ULA('NumElements',rx.nrx);
    H = phased.ConstantGammaClutter('Sensor',arr,'OperatingFrequency',...
    cfg.fc,'SampleRate',cfg.fs,'PRF',1/cfg.ts,'NumPulses',cfg.nPulses,...
    'PlatformHeight',10,'PlatformSpeed',0,'TransmitERP',mean(tx.pow),...
    'MaximumRange',cfg.Rmax,'BroadsideDepressionAngle',90);
    Y = step(H);
    Y = repmat(Y,cfg.nPulses,1);
    env.clutter = Y;
    fprintf('DONE');
% Uncomment for linux
% if(isempty(strfind(files,'clutter.mat')))
%     fprintf('\nModelling clutter...');
%     arr = phased.ULA('NumElements',rx.nrx);
%     H = phased.ConstantGammaClutter('Sensor',arr,'OperatingFrequency',...
%     cfg.fc,'SampleRate',cfg.fs,'PRF',1/cfg.ts,'NumPulses',cfg.nPulses,...
%     'PlatformHeight',10,'PlatformSpeed',0,'TransmitERP',mean(tx.pow),...
%     'MaximumRange',cfg.Rmax,'BroadsideDepressionAngle',90);
%     Y = step(H);
%     fprintf('DONE');
else
    fprintf('\nLoading clutter model...');
    clutter = load('clutter.mat');
    env.clutter = repmat(clutter.Y,cfg.nPulses,1);
    clear clutter;
	fprintf('DONE');
end

fprintf('\nTransmitting waveforms...')
tx.waveform = orthotx(cfg,mean(tx.pow),tx.ntx*tx.mtx);
fprintf('DONE')

fprintf('\nSimulating propagation...')
[rx.r,cfg.sigma_n] = propagate( cfg,tx,rx,env );
fprintf('DONE')

fprintf('\nReceiver processing...')
foo = receiver( cfg,rx,tx );
fprintf('DONE')

for i=1:rx.nrx
	eval(strcat('rx.rx',int2str(i),'=foo{',int2str(i),'};'));
end

rhat = rangecomp( cfg,rx );

fprintf('\n');
