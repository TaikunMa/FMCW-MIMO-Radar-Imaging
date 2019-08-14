function [RCS,yapl,histo] = fitMLE(TargetData)

y = abs(TargetData);

delta = 0.08; 
yapl = 0:delta:1;
PeriodTarget = size(TargetData,1);
Samples = PeriodTarget; 
histo = hist(y,yapl)./(Samples*delta);

Weibull_mle = mle(y,'distribution','wbl');
Logn_mle = mle(y,'distribution','logn');
Rayleigh_mle = mle(y,'distribution','rayl');

yweib=wblpdf(yapl,Weibull_mle(1),Weibull_mle(2));
yrayl=raylpdf(yapl,Rayleigh_mle);
yln=lognpdf(yapl,Logn_mle(1),Logn_mle(2));

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
xlabel('Amplitude (R)');
ylabel('PDF');
title('Amplitude histogram (MLE)');
legend('histo','Weibull','Rayleigh','Lognormal');
grid on;