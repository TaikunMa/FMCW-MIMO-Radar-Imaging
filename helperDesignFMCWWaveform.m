function wav = helperDesignFMCWWaveform(c,lambda)
% This function helperDesignFMCWWaveform is only in support of
% MIMORadarVirtualArrayExample. It may change in a future release.

% Copyright 2017 The MathWorks, Inc.

range_max = 200;
tm = 5.5*range2time(range_max,c);
tm = 100e-6;
range_res = 1;
bw = range2bw(range_res,c);
bw = 4e9;
sweep_slope = bw/tm;
fr_max = range2beat(range_max,sweep_slope,c);
fr_max = 10e6;

v_max = 230*1000/3600;
v_max = 5;
fd_max = speed2dop(2*v_max,lambda);

fb_max = fr_max+fd_max;
fs = max(2*fb_max,bw);
wav = phased.FMCWWaveform('SweepTime',tm,'SweepBandwidth',bw,...
    'SampleRate',fs);
