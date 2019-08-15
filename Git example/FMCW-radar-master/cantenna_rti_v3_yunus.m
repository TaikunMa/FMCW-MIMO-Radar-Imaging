function [RangeProfiles delta_r Tp dataRange Fs numPulses] = cantenna_rti_v3_yunus(wavFile)
clc

% Yunus

% function [] = cantenna_rti_v3(wavFile)
% 
% Produces an RTI (range x time intensity) image of the
% cantenna recording. Also applies a simple two-pulse 
% canceller to filter out clutter and CFAR normalization
% to improve visual detection. See inside the function
% for additional parameters.
%
%    wavFile = the filename of the .WAV file to process
%    
%% 
% Lincoln Laboratory MIT PEP Radar Course
% (c) 2012 Massachusetts Institute of Technology

%% Input parameters by user
%Yunus comment: Get from measuring actual transmit signal
fStart = 2400e6; % (Hz) LFM start frequency 
fStop = 2480e6; % (Hz) LFM stop frequency 

%% Setup constants and parameters
c = 299e6; % (m/s) speed of light
Tp = 10e-3; % (s) minimum pulse length
            % Yunus comment: Used to provide a better estimate the pulse length 

numPad = 64; % number of samples to pad for bandlimited interpolation & shifting
             % Yunus comment: Number of extra samples to take around the trigger rising edge signal
             
ovsTrg = 16; % oversampling factor applied when interpolating the trigger signal

ovsRng = 2; % oversampling factor applied when interpolating the range data
            % Yunus comment: Oversampling the IF signal by a factor of two -
            % Yunus comment:  1. Why is oversampling needed? To reduce straddle loss?
            % Yunus comment:  2. Why a factor of two?

nPulseCancel = 2; % number of pulses to use for canceller 
                  % Yunus comment: two pulse canceller
            
maxRange = 100; % (m) maximum range to display


% ----- end constants and parameters -----


% use a default filename if none is given
% if ~exist('wavFile','var')
%     wavFile = '51 Jason driving towards faster (109 MHz).wav';
% end
% Read the raw wave data
 
fprintf('Using %g MHz bandwidth\n', (fStop-fStart)*1e-6);
fprintf('Loading WAV file...\n');
[Y,Fs] = audioread(wavFile,'native');

%% Derived parameters
Np = round(Tp * Fs); % Number of samples in the chirp signal (or per pulse)
%BW = fStop - fStart; % (Hz) transmit bandwidth
BW = 109000000;
delta_r = c/(2*BW);  % (m) range resolution

%% Change the signs of the measured parameters to be more accurate
% change sign of the input because it appears inverted in practice
trig = -Y(:,1); % the trigger signal is in the first channel
                % on rising edge, the chirp signal increases 
s = -Y(:,2); % the raw mixer output is in the second channel
clear Y;

%% Estimate the actual chirp pulse length from the measured data and store in variable Tp 
% Estimate the index of the rising edge of the trigger and store in variable pulseStarts
% parse the trigger signal (look for threshold crossings)

fprintf('Parsing the recording...\n');
pulseTrig = (trig > 0);
pulseSum = sum(pulseTrig(1:Np));
pulseStarts = [];
for ii = Np+1:numel(trig)-Np-1        
    if (pulseTrig(ii) && pulseSum==0)
        pulseStarts = [pulseStarts; ii]; %#ok<*AGROW>
    end
   
    % update the running sum
    pulseSum = pulseSum + pulseTrig(ii) - pulseTrig(ii - Np);
end
clear pulseTrig;

% refine using measured parameters: the pulse width
Np = round(min(diff(pulseStarts))/2); % Np is the number of samples of the chirp pulse
                                      % pulseStarts is the index of the rising edge in samples
                                      % Want to only keep the rising edge of triangular wave
                                      % So pulsewidth is estimated by pulsestarts/2*1/fs [in seconds]
Tp = Np / Fs;
fprintf('Measured pulse width of %g ms \n', Tp*1e3);

%% Pre-compute some windows and other vectors 
Nrange = floor(ovsRng*Np/2); % number of output range samples
dataRange = (0:Nrange-1).' * (delta_r/ovsRng); % labelling the range axes in meters
dataRange = dataRange(dataRange <= maxRange); % labelling the range axes in meters upto maxRange in meters
Nrange_keep = numel(dataRange); % number of range bins which are less than maxRange in meters
%
% Setup windows to be used later
rngWin = hann_window(Np); % the window applied to reduce range sidelobes
padWin = sin( (1:numPad).'/(numPad+1) * pi/2) .^2; % the window applied to the padded data
                                    % Yunus comment: why this custom window. Why not hamming, taylor, hanning, etc
trgWin = hann_window(numPad*2+1); % the window applied to the trigger data

%  Obtain the number of pulses in the data
nSamples = numel(s);
pulseStarts = pulseStarts(pulseStarts+Np+numPad <= nSamples); % pulseStarts is the index of the rising edge in samples
numPulses = numel(pulseStarts); 
fprintf('Found %d pulses\n',numPulses);

% process pulses into a data matrix
sif = zeros(Nrange_keep,numPulses); % sif - Range lines in matrix form 
                                                                        
fprintf('Processing pulse data...\n');
for pIdx = 1:numPulses
    % bandlimited interpolate the trigger signal
    % Yunus comment: Estimate the fraction of a bin offset needed to align pulseStarts to the zero-crossing
    tmp = double(trig(pulseStarts(pIdx) + (-numPad:numPad))) .* trgWin; 
                  % Yunus comment: pulseStarts(pIdx) contains estimate of indx of zero crossing
                  % Yunus comment: need to estimate fraction offset needed to make it exactly the zero crossing
                  % Yunus comment: need this offset to align the received data                  
    interpTmp = fft_interp(tmp,ovsTrg);
    interpTmp = interpTmp( (numPad*ovsTrg + 1) + (-ovsTrg:ovsTrg) );
    interpOffs = (-ovsTrg:ovsTrg)/ovsTrg;
    myIdx = find(diff(sign(interpTmp))==2)+1;
    tmp2 = interpTmp( myIdx + (-1:0) );
    % linear interpolate to find the zero crossing
    fracOffset = -(interpOffs(myIdx) - tmp2(2)/(tmp2(2)-tmp2(1)) / ovsTrg);
    
    % time-align the data to the trigger event (the zero crossing) 
    % Apply non-integer time-shift in the frequency domain by multiplying by a phase ramp signal
    cInds = pulseStarts(pIdx) + (-numPad:(Np+numPad-1));
    tmp = double(s(cInds)); % Yunus comment: tmp = data received after chirp pulse
                            % Yunus comment: get samples from data from (rising edge-NumPad: NumSamplesChirpPulse + NumPad) 
    tmp(1:numPad) = tmp(1:numPad) .* padWin;
    tmp(end:-1:(end-numPad+1)) = tmp(end:-1:(end-numPad+1)) .* padWin;
   
    % time delay applied in the frequency domain below
    tmp = fft(tmp);
    tmp = tmp .* exp( -1j*(0:(Np+2*numPad-1)).'/(Np+2*numPad)*2*pi*fracOffset );
    tmp = ifft(tmp,'symmetric');
    
    % compute & scale range data from the time-aligned mixer output
    tmp = ifft(tmp(numPad + (1:Np)) .* rngWin, 2*Nrange); % Need to do an IFFT to get range line
    sif(:,pIdx) = tmp(1:Nrange_keep); % sif - Range lines in matrix form
                                      % sif - each column is a range profile
end
%
clear s trig;
%
sif = sif.';


% display the RTI
% figure;
% imagesc(dataRange,(0:numPulses-1)*Tp*2,20*log10(abs(sif)));
% ylabel('Time (s)');
% xlabel('Range (m)');
% title('RTI without clutter rejection');
% colormap(jet(256));
% colorbar;
% axis xy;

% apply the N-pulse canceller
mti_filter = -ones(nPulseCancel,1)/nPulseCancel;
midIdx = round((nPulseCancel+1)/2);
mti_filter(midIdx) = mti_filter(midIdx) + 1;
sif = convn(sif,mti_filter,'same');

% display the MTI results


ylabel('Time [s]');
xlabel('Range [m]');
title('RTI map');
colormap(jet(256));
colorbar;
axis xy;

%remove columns from 0 to sat_index to remove saturation
[Min MinIndexRange] = max(max(abs(sif),[],2));
sat_index = 8;
sif_trunc = sif(:,sat_index:end); 
RangeProfiles = sif_trunc;

% [aligned_data Bin_shift] = RA_correlation_v5(sif_trunc.',0,4);    %perform range alignment
figure();
subplot(2,1,1);
imagesc(dataRange,(1:numPulses)*Tp*2,20*log10(abs(sif)));
ylabel('Time [s]');
xlabel('Range [m]');
colormap(jet(256));
colorbar;
axis xy;
title('RTI map');

subplot(2,1,2);
imagesc(dataRange(9:end),(1:numPulses)*Tp*2,20*log10(abs(sif_trunc)));
ylabel('Time [s]');
xlabel('Range [m]');
colormap(jet(256));
colorbar;
axis xy;
title('RTI map for truncated data');









 
 








% ---- standard DSP helper functions below ----

function [y] = fft_interp(x,M)
% perform approximate bandlimited interpolation of x by a factor of M
L = 4;
winInds = (-L*M : L*M).'/M * pi;

% get the ideal antialiasing filter's impulse response of length 2*M + 1 
winInds(L*M + 1) = 1;
myWin = sin(winInds) ./ winInds;
myWin(L*M + 1) = 1;

% use the window method; apply a hann window
myWin = myWin .* hann_window(2*L*M + 1);

% insert zeros in data and apply antialias filter via FFT
nFFT = numel(x) * M;
if isreal(x)
    y = ifft( fft(myWin,nFFT) .* repmat(fft(x),[M 1]), 'symmetric');
else
    y = ifft( fft(myWin,nFFT) .* repmat(fft(x),[M 1]) );
end
y = y([L*M+1:end 1:L*M]);

function [w] = hann_window(N)
% create a hann (cosine squared) window
w = .5 + .5*cos(2*pi*((1:N).'/(N+1) - .5));





