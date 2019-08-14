
close all;
clear all;
clc;
[f,p]=uigetfile('.bmp');
i=strcat(p,f);
x=imread(i);
figure,imshow(x);
x=double(x);
I=1;
L=8;
% I-cerrent level
% L-Total number of levels
if I>L 
    Mout = zeros(size(x), 'like', x);
    return;
end
mean_data = nanmean(x(:));
Data0 = x;
Data1 = x;
if not(isnan(mean_data)) 
    Data0(Data0 > mean_data) = NaN;
    Data1(Data1 <= mean_data) = NaN;
end
Mout = not(isnan(Data1)) * (2^(L-I));
if I==L
    return;
end
Mean0 = SMQT(Data0, I+1, L);
Mean1 = SMQT(Data1, I+1, L);
Mout = Mout + Mean0 + Mean1;
result=Mout;
result=uint8(result);
figure,imshow(result);
title('SMQT image');
