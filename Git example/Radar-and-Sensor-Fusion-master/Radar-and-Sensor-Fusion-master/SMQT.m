function Mout = SMQT(data, I, L)% initilizes the SMQT from current level I to total level. 
% I-current level
% L-Total number of levels
if I>L % if the data is wrong, it shows zeros
    Mout = zeros(size(data), 'like', data);
    return;
end
mean_data = nanmean(data(:)); %nan means not a number, mean values data : = = all rows all colmns and planes 
Data0 = data; %initial condition
Data1 = data;
if not(isnan(mean_data)) % 
    Data0(Data0 > mean_data) = NaN;
    Data1(Data1 <= mean_data) = NaN;
end

Mout = not(isnan(Data1)) * (2^(L-I));% quantization output  
if I==L % maximum level it will end the program
    return;
end
Mean0 = SMQT(Data0, I+1, L); % above data
Mean1 = SMQT(Data1, I+1, L); % below data
Mout = Mout + Mean0 + Mean1; % 
end