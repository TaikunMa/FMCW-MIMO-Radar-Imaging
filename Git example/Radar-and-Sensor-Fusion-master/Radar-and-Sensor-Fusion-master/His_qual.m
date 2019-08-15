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
rp_h=histeq(rp);
gp_h=histeq(gp);
bp_h=histeq(bp);
out_im=cat(3,rp_h,gp_h,bp_h);
[xr1,yr1]=imhist(rp_h);
[xg1,yg1]=imhist(gp_h);
[xb1,yb1]=imhist(bp_h);
figure,subplot(221),imshow(x);
    subplot(222),imshow(out_im);
    subplot(223),plot(yr,xr,'r',yg,xg,'g',yb,xb,'b');
    subplot(224),plot(yr1,xr1,'r',yg1,xg1,'g',yb1,xb1,'b');

else
    out_im=histeq(x);
    figure,subplot(221),imshow(x);
    subplot(222),imshow(out_im);
    subplot(223),imhist(x);
    subplot(224),imhist(out_im);
end
figure,imshowpair(x,out_im,'montage');
title('orignal image and histogram equalized image');