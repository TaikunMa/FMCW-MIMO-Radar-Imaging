
close all;
clear all;
clc;
[f,p]=uigetfile('.jpg');
i=strcat(p,f);
x=imread(i);
if size(x,3)==3
rp=x(:,:,1);
gp=x(:,:,2);
bp=x(:,:,3);
[xr,yr]=imhist(rp);
[xg,yg]=imhist(gp);
[xb,yb]=imhist(bp);
out1=hist_fun(rp);% calling function
out2=hist_fun(gp);
out3=hist_fun(bp);
[xr1,yr1]=imhist(uint8(out1));%
[xg1,yg1]=imhist(uint8(out2));
[xb1,yb1]=imhist(uint8(out3));
result=cat(3,out1,out2,out3); % concatination
figure,subplot(221),imshow(x),title('original image');
    subplot(222),imshow(uint8(result)),title('output image');
    subplot(223),plot(yr,xr,'r',yg,xg,'g',yb,xb,'b'),title('histogram of input image');
    subplot(224),plot(yr1,xr1,'r',yg1,xg1,'g',yb1,xb1,'b'),title('histogram of output image');

else
    result=hist_fun(x);
     figure,subplot(221),imshow(x);
    subplot(222),imshow(result);
    subplot(223),imhist(x);
    subplot(224),imhist(result);
end
figure,imshow(uint8(result)); % unsigned integer of resulted image