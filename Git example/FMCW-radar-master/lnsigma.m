% Function for the calculation of the parameter sigma of a lognormal
% distribution by method of moments
function y=lnsigma(x,m1,m2)
y=exp(2.*(x.^2))./exp(x.^2)-m2./(m1.^2);