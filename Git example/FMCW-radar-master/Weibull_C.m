% Function for the calculation of the parameter C of a Weibull
% distribution by method of moments
function y=weibC(x,m1,m2)
y=gamma(2./x+1)./(gamma(1./x+1).^2)-m2./(m1.^2);