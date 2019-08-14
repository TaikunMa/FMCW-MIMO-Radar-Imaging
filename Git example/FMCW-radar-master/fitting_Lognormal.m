% This script performs the statistical analysis of the dataset K.mat

clc 
clear all
close all

% Generate Weibull data
m = 1; % mean
v = 1; % variance
mu = log((m^2)/sqrt(v+m^2));
sigma = sqrt(log(v/(m^2)+1));

NumValues = 100000;
z = lognrnd(mu,sigma,NumValues,1);

N=length(z); % number of samples

y=abs(z); % amplitude of the complex clutter


% vector for the histogram
delta=0.04; % Fine tuned for IPEX data
yapl=0:delta:1;
histo=hist(y,yapl)./(N*delta);

% Moments
m(1)=mean(y);
mnorm=m(1);
m(2)=mean(y.^2);
m(3)=mean(y.^3);
m(4)=mean(y.^4);
m(5)=mean(y.^5);
m(6)=mean(y.^6);
m(7)=mean(y.^7);
m(8)=mean(y.^8);


% Weibull fitting
c=fzero('Weibull_C',1,[],m(1),m(2)); % shape parameter 
b=m(1)./gamma(1./c+1); % scale parameter
%yweib=weibpdf(yapl,(1./(b.^c)),c);
yweib=wblpdf(yapl,b,c);
i=[1:1:8];
mw=b.^i.*gamma(i./c+1);   %Weibull theoretical moments

% K fitting
nu=fzero('K_nu',1,[],m(1),m(2));
mu=m(2)./2;
yk=K_pdf(yapl,nu,mu);
mk=(2.*mu).^(i./2).*gamma(nu+i./2).*gamma(i./2+1)./(nu.^(i./2).*gamma(nu));  % K theoretical moments


% Lognormal fitting
sigmal=fzero('lnsigma',1,[],m(1),m(2)); 
muln=log(m(1))-(sigmal.^2)./2; 
yln=lognpdf(yapl,muln,sigmal);
mln=exp(i.*muln+i.^2.*sigmal.^2./2);  %Lognormal theoretical moments


% Rayleigh  fitting
sigma=sqrt(2/pi)*mean(y); % parametro di scala 
yrayl=raylpdf(yapl,sigma); 
mr=(sigma.^i).*gamma(i./2+1).*2.^(i./2); %Rayleigh theoretical moments



% Figure of fittings
figure(1);
semilogy(yapl,histo,'*b',yapl,yweib,'-g',yapl,yrayl,'-k',yapl,yln,'-m','LineWidth',2);
axis([0 0.8 0.0001 50]);
xlabel('Amplitude (R)');
ylabel('PDF');
title('Amplitude histogram');
legend('histo','Weibull','Rayleigh','Lognormal');
grid on;

% Figure of moments
figure(2);
semilogy(i,m./(mnorm.^i),'*b',i,mw./(mnorm.^i),'-g',i,mr./(mnorm.^i),'-k',i,mln./(mnorm.^i),'-m','LineWidth',2)
xlabel('Moment order (n)');
ylabel('Mormalized moments');
title('Moments analysis');
legend('data','Weibull','Rayleigh','Lognormal');
grid on;

clc
disp(' ');
disp(['Weibull: c = ' num2str(roundn(c,-4)) ]);
disp(['Weibull: b = ' num2str(roundn(b,-4)) ]);
disp(' ');
disp(['Log-normal: sigma = ' num2str(roundn(sigmal,-4)) ]);
disp(['Log-normal: mu1 = ' num2str(roundn(muln,-4)) ]);
disp(' ');
disp(['Rayleigh: b = ' num2str(roundn(sigma,-4)) ]);


