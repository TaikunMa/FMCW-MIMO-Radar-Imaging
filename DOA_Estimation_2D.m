% Estimate Directions of Arrival of Two Signals
% Estimate the DOAs of two signals received by a 50-element URA with a rectangular lattice. The antenna operating frequency is 150 MHz. The actual direction of the first signal is -37° in azimuth and 0° in elevation. The direction of the second signal is 17° in azimuth and 20° in elevation.
antenna = phased.IsotropicAntennaElement('FrequencyRange',[100e6 300e6]);
% array = phased.URA('Element',antenna,'Size',[5 10],'ElementSpacing',[1 0.6]);
fc = 77e9;
c = 3e8;
lambda = c/fc;
dt = lambda/2;
% antenna_pos = [0 dt 2*dt 3*dt 4*dt 5*dt 0  dt 2*dt 3*dt 4*dt 5*dt;...
%                0 0  0    0    0    0    dt dt dt   dt   dt   dt;...
%                0 0  0    0    0    0    0  0  0    0    0    0];
% antenna_pos = [0 0  0  0    0    0    0    0    0    0    0    0;...
%                0 dt dt 2*dt 2*dt 3*dt 3*dt 4*dt 4*dt 5*dt 5*dt 6*dt;...
%                0 0  dt 0    dt   0    dt   0    dt   0    dt   dt;...
%                   ];
antenna_pos = [0 0  0    0    0    0    0    0    0    0    0    0;...
               0 dt 2*dt 3*dt 4*dt 5*dt 3*dt 4*dt 5*dt 6*dt 7*dt 8*dt;...
               0 0  0   0    0    0    dt   dt   dt   dt   dt   dt;...
                  ];
array1 = phased.ConformalArray('Element',antenna,'ElementPosition',antenna_pos);
array2 = phased.URA('Element',antenna,'Size',[2 6],'ElementSpacing',[dt dt]);
figure(1);viewArray(array1);
figure(2);viewArray(array2);
% fc = 150e6;
% lambda = physconst('LightSpeed')/fc;
ang1 = [-37.5; 10.2];
x = sensorsig(getElementPosition(array1)/lambda,8000,[ang1],0.2);
estimator = phased.BeamscanEstimator2D('SensorArray',array1,'OperatingFrequency',fc, ...
    'DOAOutputPort',true,'NumSignals',1,'AzimuthScanAngles',-50:50,'ElevationScanAngles',-30:30);
[~,doas] = estimator(x);
disp(doas)
% Because the values for the AzimuthScanAngles and ElevationScanAngles properties have a granularity of , the DOA estimates are not accurate. Improve the accuracy by choosing a finer grid
estimator2 = phased.BeamscanEstimator2D('SensorArray',array1,'OperatingFrequency',fc, ...
    'DOAOutputPort',true,'NumSignals',2,'AzimuthScanAngles',-50:0.05:50,'ElevationScanAngles',-30:0.05:30);
[~,doas] = estimator2(x);
disp(doas)

% Plot the beamscan spatial spectrum
plotSpectrum(estimator)
% Copyright 2012 The MathWorks, Inc.
