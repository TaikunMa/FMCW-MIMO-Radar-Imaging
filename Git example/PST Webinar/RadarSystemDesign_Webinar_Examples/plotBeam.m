%Copyright 2013 The MathWorks, Inc
if ii==1,
    %% Array Response
    figure('WindowStyle','docked');
    polar(degtorad(scanAz(:)),abs(resp));
    ax = gca;
else
    polar(ax,degtorad(scanAz(:)),abs(resp));
    drawnow
end