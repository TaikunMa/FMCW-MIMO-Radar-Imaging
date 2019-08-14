% This script performs the statistical analysis of the dataset K.mat

clc 
clear all
close all

% Generate Weibull data
c_W = 1.5; % shape parameter (spikiness)
           % for c_W <= 0.6 or less, K distribution estimate of nu in  invalid
           % for c_w >= 1.7, K distribution nu = 0
b_W = 1; % scale parameter (power)
NumValues = 100000;
z = wblrnd(b_W,c_W,NumValues,1);

N=length(z); % number of samples

y=abs(z); % amplitude of the complex clutter


% vector for the histogram
delta=0.1;
yapl=0:delta:max(y);
histo=hist(y,yapl)./(N*delta);

% Moments
m(1)=mean(y);
mnorm=m(1);
m(2)=mean(y.^2);
m(3)=mean(y.^3);
m(4)=mean(y.^4);
m(5)=mean(y.^5);
m(6)=mean(y.^6);


% Weibull fitting
c=fzero('Weibull_C',1.5,[],m(1),m(2)); % shape parameter 
b=m(1)./gamma(1./c+1);                % scale parameter
yweib=weibpdf(yapl,(1./(b.^c)),c);    % Weibull PDF
i=[1:1:6];
mw=b.^i.*gamma(i./c+1);   % Weibull theoretical moments

% K fitting
nu=fzero('K_nu',1.5,[],m(1),m(2));
mu=m(2)./2;                          % scale parameter
yk=K_pdf(yapl,nu,mu);                % K PDF
mk=(2.*mu).^(i./2).*gamma(nu+i./2).*gamma(i./2+1)./(nu.^(i./2).*gamma(nu));  % K theoretical moments

% Rayleigh  fitting
b_Rayleigh=sqrt(2/pi)*mean(y); % scale parameter 
yrayl=raylpdf(yapl,b_Rayleigh); 
mr=(b_Rayleigh.^i).*gamma(i./2+1).*2.^(i./2); % Rayleigh theoretical moments



% Figure of fittings
figure(1);
semilogy(yapl,histo,'*b',yapl,yweib,'-g',yapl,yk,'-.r',yapl,yrayl,'-k','LineWidth',2);
axis([0 6 0.001 10]);
xlabel('Amplitude (R)');
ylabel('PDF');
title('Amplitude histogram');
legend('histo','Weibull','K','Rayleigh');
grid on;

% Figure of moments
figure(2);
semilogy(i,m./(mnorm.^i),'*b',i,mw./(mnorm.^i),'-g',i,mk./(mnorm.^i),'-.r',i,mr./(mnorm.^i),'-k','LineWidth',2)
%axis([1 6 1 10000]);
xlabel('Moment order (n)');
ylabel('Normalized moments');
title('Moments analysis');
legend('data','Weibull','K','Rayleigh');
grid on;


clc
disp(' ');
disp(['Weibull: c = ' num2str(roundn(c_W,-3)) ', c_est = ' num2str(roundn(c,-3)) ]);
disp(['Weibull: b = ' num2str(roundn(b_W,-3)) ', b_est = ' num2str(roundn(b,-3)) ]);
disp(' ');
disp(['K distribution: nu = ' num2str(roundn(nu,-3)) ]);
disp(['K distribution: mu = ' num2str(roundn(mu,-3)) ]);
disp(' ');
disp(['Rayleigh: b = ' num2str(roundn(b_Rayleigh,-3)) ]);
