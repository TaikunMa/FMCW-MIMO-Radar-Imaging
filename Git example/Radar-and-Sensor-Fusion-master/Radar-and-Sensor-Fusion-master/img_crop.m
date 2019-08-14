close all;
clear all;
clc;
[f,p]=uigetfile('.jpg');
i=strcat(p,f);
x=imread(i);
figure,imshow(x);
title('original image');
c_image=imcrop(x);
figure,imshow(c_image);
title(' cropped image')

