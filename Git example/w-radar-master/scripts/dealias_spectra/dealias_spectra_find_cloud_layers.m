function [cbh_fin, cth_fin] = dealias_spectra_find_cloud_layers(spec, range_offsets, dr, max_dis, flag_compress_spec)

% this function determins the number of cloud layers. the maximum distance
% between two bins is allowed to be max_dis. if the distance is larger,
% then the bins are considered to belong to two separate layers
%
% input:
%   spec: radar doppler spectra (range x Nfft)
%   range_offsets: indexes where chirp sequences start
%   dr: range_resolutions of chirp sequences
%   max_dis: maximum allowed distance between two bins
%   flag_compress_spec: flag for compressed spectra (true/false)
%
% output:
%   cbh_fin: array containing indexes of cloud base heights
%   cth_fin: array containing indexes of cloud top heights


ss = size(spec);

% find cloud layers
signal = zeros(ss(1),1);

if flag_compress_spec
    signal( any( ~isnan(spec), 2) ) = 1;

else
    signal(~isnan(spec(:,1))) = 1;
end



dsignal = diff(signal);

if sum(dsignal) == 0 % then there is either no signal or signal in whole column
    cbh_fin(1) = 1;
    cth_fin(1) = ss(1);
    return
end

cth = find(dsignal == -1);
cbh = find(dsignal == 1) + 1;

if signal(1) == 1 % then there is signal in the first bin
    cbh = [1; cbh];
end
if signal(end) == 1 % then there is signal in the last bin
    cth(end+1) = ss(1);
end


% compare cth(i+1) and cbh(i) to estimate the gap, i.e. if there is just a
% few meters missing
temp = numel(cth)-1;
dlayers = zeros(temp,1);
for i = 1:temp
    if cbh(i) < range_offsets(2)
        dlayers(i) = (cbh(i+1) - cth(i))*dr(1);    
    elseif cbh(i) < range_offsets(3)
        dlayers(i) = (cbh(i+1) - cth(i))*dr(2);  
    elseif cbh(i) < range_offsets(4)
        dlayers(i) = (cbh(i+1) - cth(i))*dr(3);
    else 
        dlayers(i) = (cbh(i+1) - cth(i))*dr(4);
    end

end

i = 1;
cc = 1;
while i <= temp
    idx = find(dlayers(i:end) > max_dis,1,'first') + i - 1; % find next layer, i.e. cbh and cth must differ by more than max_dis m
    if i == 1 && isempty(idx) % then it is just one cloud
        cbh_fin(cc) = cbh(1);
        cth_fin(cc) = cth(end);
        i = temp+1;
    elseif isempty(idx) % all follwing layers are one layer
        cbh_fin(cc) = cbh(i);
        cth_fin(cc) = cth(end);
        i = temp+1;
    else
        cbh_fin(cc) = cbh(i);
        cth_fin(cc) = cth(idx);
        i = idx+1;
        cc = cc + 1;
    end

end

if numel(cbh) == 1 % then there is only one layer
    cbh_fin = cbh;
    cth_fin = cth;
end

if ne(cth_fin(end),cth(end)) % then last layer is a single layer
    cth_fin(end+1) = cth(end);
    cbh_fin(end+1) = cbh(end);
end

