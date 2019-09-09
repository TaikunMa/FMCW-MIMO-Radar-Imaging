%% Using FFT instead of phased.BeanscanEstimator
%% Get Range, Velocity, Spacial location of the given data cube
function [TargetNum TargetInformation] = Data_Cube_Imaging(DataCube,...
                                nfft_r,...
                                nfft_d,...
                                fc,...
                                fs,...
                                SweepTime,...
                                SweepBandwidth,...
                                Nt,...
                                Nr,...
                                RD_Th)
%Input definition
%   DataCube        : Data matrix with dimension of range-channel-chirp.
%   nfft_r          : FFT points on range dimension 
%   nfft_d          : FFT points on doppler dimension
%   fc              : Carrier frequency
%   fs              : Sample rate
%   SweepTime       : Chirp-up time
%   SweepBandwidth  : Chirp bandwidth
%   Nt              : Number of Tx antennas
%   Nr              : Number of Rx antennas
%   RD_Th           : Threat relative dB on range-doppler map
%   Detailed explanation goes here

%% Antenna Array Definition
c = 3e8;
lambda = c/fc;
dA = 2.34e-3;
dBy = dA * 3;
dBz = 1.95e-3;

AngleB_Index = -90:1:90;
AngleA_Index = -55:1:55;

angA_sin = lambda/dA*AngleA_Index/111;
angB_sin = lambda/dBz*AngleB_Index/181;
phi = asin(angB_sin);
SpatialAngleMap_Phi = repmat(phi.',1,111);

Theta_sin = angA_sin.'*(1./(sqrt(1-angB_sin.^2)));
SpatialAngleMap_Theta = asin(Theta_sin.');

SpatialAngleMap_Theta(find(imag(SpatialAngleMap_Theta) ~= 0)) = 100;

%%  Range-Doppler detection
rngdop = phased.RangeDopplerResponse('PropagationSpeed',c,...
    'DopplerOutput','Speed','OperatingFrequency',fc,'SampleRate',fs,...
    'RangeMethod','FFT','PRFSource','Property',...
    'RangeWindow','Hann','PRF',1/(Nt*SweepTime),...
    'SweepSlope',SweepBandwidth/SweepTime,...
    'RangeFFTLengthSource','Property','RangeFFTLength',nfft_r,...
    'DopplerFFTLengthSource','Property','DopplerFFTLength',nfft_d,...
    'DopplerWindow','Hann');
[RangeDoppler,RangeGrid,DopplerGrid] = rngdop(DataCube);

%% Range-Doppler peaks found
RangeDopplerMap = squeeze(mag2db(abs(RangeDoppler(:,1,:))));
RangeDopplerMap = RangeDopplerMap-max(RangeDopplerMap(:));                     % Normalize map
peakmat = findpeaks2D(RangeDopplerMap,0,RD_Th);   
[RangeIndex,DopplerIndex] = ind2sub(size(RangeDopplerMap),find(peakmat));

%% Velocity compensation
TargetNum = length(RangeIndex);
AngleData = zeros(TargetNum,Nt*Nr);
for i=1:TargetNum
    AngleData(i,:) = RangeDoppler(RangeIndex(i),:,DopplerIndex(i));
end
% for i=2:Nt
%     AngleData(:,((i-1)*Nr+1):i*Nr) = AngleData(:,((i-1)*Nr+1):i*Nr).*exp(1i*2*pi*2*fc*DopplerGrid(DopplerIndex)*(i-1)*SweepTime/3e8);
% end

%% Angle detection
AngleIndex = zeros(2,TargetNum);
for i=1:TargetNum
    AngleDataMap = zeros(2,6);
    AngleDataMap(1,:) = AngleData(i,1:6)';
    AngleDataMap(2,:) = AngleData(i,7:12)';
    AngleDataFFT_1 = fftshift((fft(AngleDataMap,111,2)),2);
    
    figure(1);
    plot(abs(AngleDataFFT_1(1,:)));
    
    AngleDataFFT_1(2,:) = AngleDataFFT_1(2,:).*exp(-1j*(-55:1:55)/111*2*pi*dBy/dA);
    AngleDataFFT_2 = fftshift((fft(AngleDataFFT_1,181,1)),1);
    
    AngleDataFFT_2(find(SpatialAngleMap_Theta == 100)) = 0;
    figure(2)
    mesh(abs(AngleDataFFT_2));
    
    Power = abs(AngleDataFFT_2);
    
    figure(2);
    mesh((abs(AngleDataFFT_2)));
    
    [target_B, target_A] = ind2sub(size(AngleDataFFT_2),find(abs(AngleDataFFT_2)));
    Power1 = abs(AngleDataFFT_2(find(abs(AngleDataFFT_2))));
    
    for i=1:length(target_B)
        target_AZ(i) = SpatialAngleMap_Theta(target_B(i),target_A(i));
        target_EL(i) = SpatialAngleMap_Phi(target_B(i),target_A(i));
    end
    
    Power = mag2db(Power1);
    Power = Power - max(max(max(Power)));
    Power(Power < -19) = -19;
    Power = ceil((Power+20)/2);
    
    cmap = colormap(parula(10));
    c = cmap(Power,:);
    
    figure(3);
    scatter3(target_AZ,target_EL,Power,[],c);
    
    Target_Range = 8*ones(1,length(target_B));
    Target_R = (3e8) * (200e-6) / 2 / (77e9) * (1e9) * Target_Range / 1024;
    [Target_X, Target_Y, Target_Z] = sph2cart(target_AZ,target_EL,Target_R);
    

    

    
    figure(4);
    scatter3(Target_X,Target_Y,Target_Z,[],c);
    xlabel('X');xlim([0 10]);
    ylabel('Y');ylim([-8 8]);
    zlabel('Z');zlim([-2 2]);
    pause(0.1);
    
    

end


disp(AngleIndex);
TargetInformation = zeros(4,TargetNum);
TargetInformation(3,:) = -RangeGrid(RangeIndex);
TargetInformation(1:2,:) = -AngleIndex;
TargetInformation(4,:) = -DopplerGrid(DopplerIndex);


end

