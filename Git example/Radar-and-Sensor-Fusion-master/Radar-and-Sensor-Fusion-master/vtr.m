close all;
clear all;
clc;
[f,p]=uigetfile('.jpg'); %Selection of image w.r.t. filename and path
i=strcat(p,f);% string concatination
x=imread(i);% selected image
[ro, co, d] = size(x); 
if (d==3) % if the image has 3 dimensions, its an rgb imae
rp=x(:,:,1);
gp=x(:,:,2);
bp=x(:,:,3);
[xr,yr]=imhist(rp);% histogram
[xg,yg]=imhist(gp);
[xb,yb]=imhist(bp);
HSVimage = rgb2hsv(x);% transform from RGB to HSV
V = HSVimage(:,:,3); % Getting V component (BRIGHTNESS)
else %if the image has 1Dimension, it is a graty-scale image 
V =double(x)/255; % In this case, we don't need to transform
end
n=2;% iterations levels // by increasing levels we 
V=V(:);%The matrix of brightness is now a vertical vector
[Vsorted, ix] = sort(V); %sort in ascending order ix location
s = (ro*co)/n; % size of the intervals
i=0; % initializing i
h=[]; % initializing empty matrix h
while (i < n)
i=i+1; 
int = Vsorted(((floor(s*(i-1))+1)):floor(s*i)); % we define interval
Vstart = (s*(i-1))/(ro*co); %initial  interval
Vstop = (s*i)/(ro*co);% final interval
r=int-int(1); 
f = (1/n)/(r(size(r,1))); % 
g = r*f;
if(isnan(g(1)))
g = r + Vstop;
else
g = g + Vstart;
end
h=vertcat(h,g); %builting the transformed vector
end
m(ix)=h;  % we perform reverse sorting of vector, with the fransformed values
m=m(:);
if(d==3) % resizing the vector into a matrix and assigning the new V component
HSVimage(:,:,3) = reshape(m,ro,co);
A=hsv2rgb(HSVimage); % conversion of hsv to rgb
rp1=A(:,:,1);
gp1=A(:,:,2);
bp1=A(:,:,3);
[xr1,yr1]=imhist(rp1);
[xg1,yg1]=imhist(gp1);
[xb1,yb1]=imhist(bp1);
figure,subplot(2,2,1),imshow(x),title('Input')
       subplot(2,2,2),imshow(A),title('Output for n= 2');
       subplot(2,2,3),plot(yr,xr,'r',yg,xg,'g',yb,xb,'b'),title('Input histogram')
       subplot(2,2,4),plot(yr1,xr1,'r',yg1,xg1,'g',yb1,xb1,'b');title('Output histogramfor n= 2')
      
else
A=reshape(m,ro,co);% if it is not 3d image
 figure 2,subplot(221),imshow(x);
    subplot(222),imshow(A);
    subplot(223),imhist(x);
    subplot(224),imhist(A);
end

figure,
imshow(A),title('Output at n= 2');