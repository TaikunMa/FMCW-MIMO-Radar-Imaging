function [rangeidx,dopidx] = helperRDDetection(respmap,th)
% This function helperRDDetection is only in support of
% MIMORadarVirtualArrayExample. It may change in a future release.

% Copyright 2017 The MathWorks, Inc.

respmap = respmap-max(respmap(:));                     % Normalize map
peakmat = phased.internal.findpeaks2D(respmap,0,th);   
[rangeidx,dopidx] = ind2sub(size(respmap),find(peakmat));
