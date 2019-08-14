
function out=hist_fun(in)% assigning input image
[r,c]=size(in); % size of image in rows and colmns
his=imhist(in);% histogram value representation
in=double(in); %convert input into double floating point
probability=his./(r*c);% calculate probability of gray level pixel
equaliz = cumsum(probability)*256;% cummulated probability and weights
out=equaliz(in+1); % replace grey level pixels in function of equlizer
end
