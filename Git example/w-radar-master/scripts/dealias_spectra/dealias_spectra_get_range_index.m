function r_idx = dealias_spectra_get_range_index(range_offsets, ii)

% this function returns the number of the chirp in which the range
% 'ii' is contained

% input:
%   range_offsets: contains the indexes in where a new chrip sequence
%       starts, plus a large number as last entry, e.g. [1,20,10^5]
%   ii: current range bin index

% get range indexes
for iii = 2:numel(range_offsets)
    if ii < range_offsets(iii)
        r_idx = iii - 1;
        break
    end
end