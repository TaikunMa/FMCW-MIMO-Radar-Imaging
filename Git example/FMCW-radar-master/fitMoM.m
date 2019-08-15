

function [RCS,yapl,histo] = fitRCS(TargetData)

y = abs(TargetData);

delta = 0.08; 
yapl = 0:delta:1;
PeriodTarget = size(TargetData,1);
Samples = PeriodTarget; 
histo = hist(y,yapl)./(Samples*delta);

m = 1;
m(1) = mean(y);
mnorm =m(1);
m(2) = mean(y.^2);
m(3) = mean(y.^3);
m(4) = mean(y.^4);
m(5) = mean(y.^5);
m(6) = mean(y.^6);
m(7) = mean(y.^7);
m(8) = mean(y.^8);

% Weibull fitting
c=fzero('Weibull_C',1,[],m(1),m(2)); % shape parameter 
b=m(1)./gamma(1./c+1); % scale parameter
%yweib=weibpdf(yapl,(1./(b.^c)),c);
yweib=wblpdf(yapl,b,c);

i=1:1:8;
mw=b.^i.*gamma(i./c+1);   %Weibull theoretical moments

% Lognormal fitting
sigmal=fzero('lnsigma',1,[],m(1),m(2)); 
muln=log(m(1))-(sigmal.^2)./2; 
yln=lognpdf(yapl,muln,sigmal);
mln=exp(i.*muln+i.^2.*sigmal.^2./2);  %Lognormal theoretical moments

% Rayleigh  fitting
sigma=sqrt(2/pi)*mean(y); % parametro di scala 
yrayl=raylpdf(yapl,sigma); 
mr=(sigma.^i).*gamma(i./2+1).*2.^(i./2); %Rayleigh theoretical moments

%Choose Best Fit
Weibull_mle_temp = yweib;

%Remove infinity from data
infidx = find(isinf(Weibull_mle_temp));
Weibull_mle_temp(isinf(Weibull_mle_temp)) = Weibull_mle_temp(infidx+1);

%Error Estimation between histrogram data and pdf models
WeibullError = immse(histo,Weibull_mle_temp);
RayleighError = immse(histo,yrayl);
LNError = immse(histo,yln);

Errors = [WeibullError RayleighError LNError]; %Matrix of errors

BestFit = min(Errors);
if BestFit == WeibullError
    RCS = yweib;
elseif BestFit == RayleighError
    RCS = yrayl;
elseif BestFit == LNError
    RCS = yln;
end


% Figure of fittings
figure();
semilogy(yapl,histo,'*b',yapl,yweib,'-g',yapl,yrayl,'-k',yapl,yln,'-m','LineWidth',2);
%axis([0 0.8 0.0001 50]);
xlabel('Amplitude (R)');
ylabel('PDF');
title('Amplitude histogram (MoM)');
legend('histo','Weibull','Rayleigh','Lognormal');
grid on;

% Figure of moments
% semilogy(i,m./(mnorm.^i),'*b',i,mw./(mnorm.^i),'-g',i,mr./(mnorm.^i),'-k',i,mln./(mnorm.^i),'-m','LineWidth',2)
% xlabel('Moment order (n)');
% ylabel('Normalized moments');
% title('Moments analysis');
% legend('Targetdata','Weibull','Rayleigh','Lognormal');
% grid on;

figure();
histogram(y);

disp(' ');
disp(['Weibull: c = ' num2str(roundn(c,-4)) ]);
disp(['Weibull: b = ' num2str(roundn(b,-4)) ]);
disp(' ');
disp(['Log-normal: sigma = ' num2str(roundn(sigmal,-4)) ]);
disp(['Log-normal: mu1 = ' num2str(roundn(muln,-4)) ]);
disp(' ');
disp(['Rayleigh: b = ' num2str(roundn(sigma,-4)) ]);

%MLE







end