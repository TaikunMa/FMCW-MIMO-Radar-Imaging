function status = dealias_spectra_vm_cloumn_quality_check_flag_data(vm, status)

% input:
%   vm: mean doppler velocity
%   status: status of dealiasing
%
% output:
%   status: if significant differnce to neighbour bins is detected status =
%   status + 2^3 (see data.AliasStats)

svm = size(vm);

dbin = 5;
dvm = 5;

for i = 1:svm(1)
    
    a = i - dbin;
    b = i + dbin;
    c = i - 1;
    d = i + 1;
    
    if a < 1,  a = 1; end
    
    if b > svm(1), b = svm(1); end
    
    if c < 1, c = 1; end
    
    if d > svm(1), d = svm(1); end
   
    tempmean = nanmean(vm(a:c,:))/2 + nanmean(vm(d:b,:))/2;
    
    idx_flag = abs(vm(i,:) - tempmean) > dvm;
    
    status(i,idx_flag) = status(i,idx_flag) + 2^3;
    
end
    