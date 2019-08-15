function helperslexMFSKMultiTargetsParam
% This function helperslexMFSKMultiTargetsParam is only in support of
% slexMFSKMultiTargetsExample. It may be removed in a future release.

%   Copyright 2014 The MathWorks, Inc.

paramMFSKMT.Fs = 151e6;
paramMFSKMT.bw = 150e6;
paramMFSKMT.Tstep = 2e-6;
paramMFSKMT.Nstep = 1024;
paramMFSKMT.T = paramMFSKMT.Tstep*paramMFSKMT.Nstep;
paramMFSKMT.Nsampperstep = round(paramMFSKMT.Fs*paramMFSKMT.Tstep);
paramMFSKMT.Foffset = -294e3;
paramMFSKMT.beatfreq_vec = (0:paramMFSKMT.Nstep/2-1).'/(paramMFSKMT.Nstep/2)/(2*paramMFSKMT.Tstep);
paramMFSKMT.ppow = 0.00316227766016838;
paramMFSKMT.TxGain = 36.0042142909402;
paramMFSKMT.RadarVel = [ 100*1000/3600; 0; 0];
paramMFSKMT.RadarPos = [0;0;0];
paramMFSKMT.Fc = 77e9;
paramMFSKMT.RCS = 50;
paramMFSKMT.CarVel = [ 60*1000/3600; 0; 0]; 
paramMFSKMT.CarPos = [50;0;0];
paramMFSKMT.C = 3e8;
paramMFSKMT.NF = 4.5;
paramMFSKMT.RxGain = 42.0042142909402;
paramMFSKMT.slope = paramMFSKMT.bw/paramMFSKMT.T;
paramMFSKMT.lambda = paramMFSKMT.C/paramMFSKMT.Fc;
paramMFSKMT.TruckRCS = 1000;
paramMFSKMT.TruckVel = [ 130*1000/3600; 0; 0]; 
paramMFSKMT.TruckPos = [150;0;0];   
paramMFSKMT.RDDecoupleCoeff = [paramMFSKMT.slope 1;...
    paramMFSKMT.Foffset paramMFSKMT.Tstep];

assignin('base','paramMFSKMT',paramMFSKMT)