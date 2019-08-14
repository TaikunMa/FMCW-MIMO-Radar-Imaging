% Function for the calculation of the parameter nu of a K
% distribution by method of moments
function y=keynu(x,m1,m2)
y=(4.*x.*gamma(x).^2)./(pi.*gamma(x+0.5).^2)-m2./(m1.^2);