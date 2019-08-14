function helperPlotMultipledBPattern(ang,pat,yregion,legendstr,titlestr,lstyle,lwidth)
% This function helperPlotMultipledBPattern is only in support of
% MIMORadarVirtualArrayExample. It may change in a future release.

% Copyright 2017 The MathWorks, Inc.

narginchk(5,7);
h = plot(ang,pat-max(pat));
xlabel('Angle (deg)');
ylabel('Power (dB)');
grid on;
ylim(yregion);
legend(legendstr);
title(titlestr);
numline = numel(h);
if nargin > 5
    if nargin < 7
        lwidth = ones(numline);
    end
    for m = 1:numline
        h(m).LineStyle = lstyle{m};
        h(m).LineWidth = lwidth(m);
    end
end

