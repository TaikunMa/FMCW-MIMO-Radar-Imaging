
% Description: 
%
% Inputs: Matrix to be aligned 
%         OrderPolyFit of polyfit to data
%         SlidingWindowInProfiles: sliding window for reference profile (in profiles)
%         
%
% Outputs: AlignedProfiles

%Assumptions:

%The algorithm requires that a dominant scatterer which is 
%locked onto for the duration of the processing interval be present.
%
% Version 5: Correlation Range Alignment
%            Reference profile = sum of a set of previously aligned profiles (sliding window)
%            Correlation limited to a fixed number of bin shifts. ie:  -0.5:0.0025:0.5
%            Non-integer bin shifts
%            Shift done in frequency domain

function [AlignedProfiles,BinShiftsEstimate] = RA_correlation_v5(NonAlignedProfiles,OrderPolyFit, SlidingWindowInProfiles)

BinShiftsToImplementInitial = -0.5:0.0025:0.5;
BinShiftsToImplement = BinShiftsToImplementInitial;

% Obtain the number of profiles and 
[No_Profile_Samples,No_Profiles] = size(NonAlignedProfiles);
%Correlate each profile with the first

% Get reference profile

size(NonAlignedProfiles)

RefProfile = abs(NonAlignedProfiles(:,1));

CorrelationMaxBinVector = zeros(1,No_Profiles);
for m = 1: No_Profiles
    
    % Obtain current profile to be aligned
    ProfileNotAligned = NonAlignedProfiles(:,m);
        
    % Shift by different non-integer bin shifts and store as a matrix
    LengthProfile = length(ProfileNotAligned);
    k = (0:1:(LengthProfile-1)).';

    NonIntegerShiftingMatrix = exp(1i*2*pi*k/LengthProfile*BinShiftsToImplement);
    Profile2AlignMatrix = repmat(ProfileNotAligned,1,length(BinShiftsToImplement));
    ShiftedProfile2AlignMatrix = ifft(fft(Profile2AlignMatrix,[],1).*NonIntegerShiftingMatrix, [], 1);

   % Correlate reference profile with Unaligned profile shifted by multiple non-integer bin shifts
   % Correlation value with the highest value gives the estimated bin shift value          
   
     CorrelationMatrix = repmat(abs(RefProfile), 1, length(BinShiftsToImplement)).*abs(ShiftedProfile2AlignMatrix);
     [MaxVal MaxCol] = max(max(abs(CorrelationMatrix)));
     


     [MaxRowVal_v MaxRowIdx_v] = max(abs(CorrelationMatrix));
     MaxRowIdx = MaxRowIdx_v(1);

     % Obtain bin shifts required
      CorrelationMaxBinVector(m) = BinShiftsToImplement(MaxCol);
      
      disp(['Profile num =' num2str(m) ' of ' num2str(No_Profiles) ', bin shift = ' num2str(CorrelationMaxBinVector(m)) ', Min = ' num2str(BinShiftsToImplement(1)) ', Max = ' num2str(BinShiftsToImplement(end)) ]);
      
     % Update Reference profile
     AlignedCurrentProfile = ShiftedProfile2AlignMatrix(:, MaxCol);
     
     AlignedMatrix(:,m) = AlignedCurrentProfile;
     
     if m > 1 && m <= SlidingWindowInProfiles   
        %RefProfileNew = (m-1)/(m)*mean(abs(AlignedMatrix(:,1:(m-1))),2) + 1/m*abs(AlignedCurrentProfile); 
        RefProfileNew = mean(abs(AlignedMatrix(:,1:m)),2); 
        RefProfile = RefProfileNew;
     elseif m > 1 && m > SlidingWindowInProfiles
        %RefProfileNew = SlidingWindowInProfiles/(SlidingWindowInProfiles+1)*mean(abs(AlignedMatrix(:,(m-SlidingWindowInProfiles+1):(m-1))),2) + 1/(SlidingWindowInProfiles+1)*abs(AlignedCurrentProfile);
        RefProfileNew = mean(abs(AlignedMatrix(:,1:m)),2); 
        RefProfile = RefProfileNew;
     else
        % do nothing 
         
     end
      
     % Update bin shifts vector so that previous bin shift is in the middle of search space
     BinShiftsToImplement = BinShiftsToImplement(MaxCol) + BinShiftsToImplementInitial;
     
end

BinShiftsEstimate = CorrelationMaxBinVector - CorrelationMaxBinVector(1);






   
% Fit a low order polynomial to the bin shifts estimate
if OrderPolyFit > 0 
     coeff_polyfit = polyfit(1:No_Profiles, BinShiftsEstimate, OrderPolyFit);
     bin_shifts_smooth = polyval(coeff_polyfit, 1:No_Profiles);

     figure; plot(BinShiftsEstimate, 'b-');
     hold on; plot(bin_shifts_smooth,'r-');
     xlabel('Profile number');
     ylabel('Integer Bin Shift');
     grid on;
     legend('Before smoothing', 'After smoothing');
     title('Pre/Post Smoothing');
     
     figure; histogram(BinShiftsEstimate);
     title('Histogram');
     
        
     bin_shifts =  bin_shifts_smooth; % with polyfit
else
      bin_shifts = BinShiftsEstimate; % without polyfit
end

%Frequency shift method
freq_matrix = repmat((0:1:No_Profile_Samples-1)',1,No_Profiles);
shift_matrix = repmat(bin_shifts,No_Profile_Samples,1);
freq_shift = exp(j*2*pi/No_Profile_Samples*freq_matrix.*shift_matrix);

%Aligned Matrix Returned
AlignedProfiles = ifft(fft(NonAlignedProfiles).*freq_shift);


