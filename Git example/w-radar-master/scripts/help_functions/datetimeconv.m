
function timeout = datetimeconv(yy,mm,dd,hh,mmm,ss)
% function to convert date and time to the time format used in the program
% RG 9.7.2019

    timeout  = datenum([yy,mm,dd,hh,mmm,ss])*86400 - datenum([2001 1 1])*86400;
end % function

