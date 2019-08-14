function [moment_string, nf, nf_string, nbins, range_offsets, ...
            flag_compress_spec] = dealias_spectra_varargin_check(ss, varargin)


moment_string = find(strcmp(varargin,'moment_str'), 1)+1;
if ~isempty(moment_string)
    if strcmp(moment_string,'Ze')
        moment_string = 'vm';
    else
        moment_string = varargin{moment_string};
    end
else
    moment_string = 'vm';
end
    
pnf = find(strcmp(varargin,'pnf'), 1)+1;
mnf = find(strcmp(varargin,'mnf'), 1)+1;

if isempty(pnf) && isempty(mnf)
    nf = 1.2;
    nf_string = 'pnf';
elseif isempty(pnf)
    nf = varargin{mnf};
    nf_string = 'mnf';
else
    nf = varargin{pnf};
    nf_string = 'pnf';
end

nbins = find(strcmp(varargin,'nbins'), 1)+1;
if ~isempty(nbins)
    nbins = varargin{nbins};
else
    nbins = 3;
end

range_offsets = find(strcmp(varargin,'range_offsets'), 1)+1;
if ~isempty(range_offsets)
    range_offsets = varargin{range_offsets};
    range_offsets(end+1) = ss(1)+1;    
else
    range_offsets = [1,ss(1)+1,10*ss(1),10*ss(1)];
end



ix = find(strcmp(varargin,'comp_flag'), 1);
if ~isempty(ix)
    flag_compress_spec = varargin{ix+1};
else
    flag_compress_spec = false;
end

