function helperslexFMCWMultiTargetsSim(command)
% This function helperslexFMCWSim is only in support of slexFMCWExample. It
% may be removed in a future release.

%   Copyright 2014 The MathWorks, Inc.

switch command
    case 'openModel'
        open_system('slexFMCWMultiTargetsExample');
        helperslexFMCWMultiTargetsSim('closePlots');
    case 'closePlots'
        close_system('slexFMCWMultiTargetsExample/FMCW Spectrogram');
        showRangeDopplerMap('off');
    case 'runModel'
        sim('slexFMCWMultiTargetsExample');
        helperslexFMCWMultiTargetsSim('closePlots');
    case 'showFMCWSpectrogram'
        openForPublish('slexFMCWMultiTargetsExample/FMCW Spectrogram');
    case 'showRangeDopplerMap'
        showRangeDopplerMap('on');
    case 'showSignalProcessing'
        openForPublish('slexFMCWMultiTargetsExample/Signal Processing');
    case 'showRangeDopplerJointEstimation'
        openForPublish('slexFMCWMultiTargetsExample/Signal Processing/Upsweep Estimate');
    case 'closeModel'
        close_system('slexFMCWMultiTargetsExample',0);
end

function openForPublish(blk)
open_system(blk,'force');

function showRangeDopplerMap(flag)
h = findall(0,'Type','Figure','Name','slexFMCWMultiTargetsExample/Visualization/Range Doppler Map');
set(h,'Visible',flag);

