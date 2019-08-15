clear
clc
%Get RTI Data
[RangeProfiles Res Tp dataRange Fs numPulses] = cantenna_rti_v3_yunus('42 Imraan driving away 15kmph VW.wav');
%Align Profiles



[AlignedData BinShift] = RA_correlation_v5(RangeProfiles.',0,4);

figure()
imagesc(dataRange(9:end),(1:size(AlignedData,2))*Tp*2,20*log10(abs(AlignedData.')));
ylabel('Time');
xlabel('Range');
colormap(jet(256));
colorbar;
axis xy;
title('Range Aligned Profiles');

AlignedDataMag = abs(AlignedData);
aligned_data = AlignedData(:,1:end-50);
BinShift = BinShift(1:end-50);
RangeProfiles = RangeProfiles(1:end-50,:).';

[MaxPower MaxIndexTime] = max(max(abs(aligned_data),[],1));





%Find Distance from radar for each return and compensate data
Range_shift = BinShift*Res;
R3 = (abs(Range_shift)).^3;
aligned_dataR3 = bsxfun(@times,aligned_data,R3);  

MaxR3 = max(R3);
aligned_dataR3Norm = aligned_dataR3./MaxR3;
aligned_dataR3NormMag = abs(aligned_dataR3Norm);
%Get index over range and time for target window
[Ridx Tidx] = TargetFocus(aligned_data);
TargetWindow = aligned_dataR3(Ridx,:);

%Other scalars for RCS
fc = 2440e6;
c = 299e6;
lambda = c/fc;


%Average Profiles normalized over Range
ProfileAvg_R = mean(abs(aligned_data),2);
ProfileAvgNorm_R = ProfileAvg_R/max(ProfileAvg_R);
ProfileAvgNormDB_R = 20*log10(abs(ProfileAvgNorm_R));


%Average Power Compensated Profiles normalized over Time/Samples
ProfileAvgR3_R = mean(abs(aligned_dataR3),2);
ProfileAvgNormR3_R = ProfileAvgR3_R/max(ProfileAvgR3_R);
ProfileAvgNormR3DB_R = 20*log10(abs(ProfileAvgNormR3_R));

figure();

subplot(2,1,1);
plot(ProfileAvgNormDB_R());
subplot(2,1,2);
plot(ProfileAvgNormR3DB_R());

DataRangeTrunc = dataRange(8:end);

%Plot Aligned And Power Compensated Profiles
figure();
subplot(3,1,1)
plot(DataRangeTrunc,(abs(RangeProfiles(:,1:20:end))))
title('Range Profiles');
xlabel('Range [m]');
ylabel('Amplitude');
subplot(3,1,2)
plot(DataRangeTrunc,(abs(aligned_data(:,1:20:end))));
title('Aligned Profiles');
xlabel('Range [m]');
ylabel('Amplitude');
subplot(3,1,3)
plot(DataRangeTrunc,(abs(aligned_dataR3(:,1:20:end))));
title('Aligned Profiles Power Compensated ');
xlabel('Range [m]');
ylabel('Amplitude');
%Correlation Coefficient
TimeFocused = aligned_dataR3(:,Tidx);
for i = 1:size(TimeFocused)
    CorrCoeff(i) = corr2(abs(TimeFocused(:,i)),abs(TimeFocused(:,i+1)));
end

coeff = mean(CorrCoeff);

%Sum Profiles over range window to give vector 
SumTarget = sum(TargetWindow,1);
FocusedReturn = SumTarget(Tidx).';
y = abs(FocusedReturn);
NumSamplesTarget = size(FocusedReturn,1); 


figure()
plot((1:NumSamplesTarget)*Tp*2,20*log10(y));
title('Sum Returns');
axis tight

%Histogram

figure()
histogram(y,'normalization','probability');
title('RCS distribution');
ylabel('Probability')
xlabel('RCS [m^2]')



TargetNorm = normalize(FocusedReturn);
fitMLE(TargetNorm);