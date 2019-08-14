close all;
clear all;
clc;
[f,p]=uigetfile('.jpg'); % select image from a folder (image acquisition)
i=strcat(p,f); % string concatination path name, filename and storing in 'i'
x1=imread(i); %reading input images
% figure,imshow(x);
%for 3d image SMQT 
x=double(x1); %double precision floating point== it reduces the intensity of the image
if size(x,3)==3 % Size of the matrix X = 3 is planes
rp=x(:,:,1);% rows,columns,planes i.e red plane
gp=x(:,:,2);%green plane
bp=x(:,:,3);%blue plane
[xr,yr]=imhist(uint8(rp));% histogram repesentation of red plane
[xg,yg]=imhist(uint8(gp));% histogram repesentation of green plane
[xb,yb]=imhist(uint8(bp));% histogram repesentation of blue plane
rp_out=SMQT(rp,1,8); % SMQT for red plane
rp_out=uint8(rp_out);% unsign integer
gp_out=SMQT(gp,1,8);
gp_out=uint8(gp_out);
bp_out=SMQT(bp,1,8);
bp_out=uint8(bp_out);
[xr1,yr1]=imhist(rp_out);
[xg1,yg1]=imhist(gp_out);
[xb1,yb1]=imhist(bp_out);
result=cat(3,rp_out,gp_out,bp_out);% concatination 3 planes
figure,subplot(2,2,1),imshow(x1), title(' Input ');; % selected image
       subplot(2,2,2),imshow(result), title(' output ');;% output enhanced image
       subplot(2,2,3),plot(yr,xr,'r',yg,xg,'g',yb,xb,'b'), title(' Histogram for input');;
       subplot(2,2,4),plot(yr1,xr1,'r',yg1,xg1,'g',yb1,xb1,'b'),title('Histogram for output ');;
      
else
    %SMQT enhance for 2D grey scal image
    result=SMQT(x,1,8);% Applying SMQT for grey scale image
    result=uint8(result);
figure,
subplot(2,2,1),imshow(x1);
subplot(2,2,2),imshow(result);
subplot(2,2,3),imhist(x1);
subplot(2,2,4),imhist(result);
title('histograms SMQT output');
end
% figure,imshow(result);
figure,imshowpair(x1,result,'montage'); 
title(' Original image and SMQT image');
