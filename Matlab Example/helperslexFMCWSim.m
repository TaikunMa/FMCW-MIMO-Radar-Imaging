function helperslexFMCWSim(command)
% This function helperslexFMCWSim is only in support of slexFMCWExample. It
% may be removed in a future release.

%   Copyright 2014 The MathWorks, Inc.

switch command
    case 'openModel'
        open_system('slexFMCWExample');
        helperslexFMCWSim('closePlots');
    case 'closePlots'
        close_system('slexFMCWExample/FMCW Spectrogram');
        close_system('slexFMCWExample/Dechirped Signal Spectrogram');
    case 'runModel'
        sim('slexFMCWExample');
        helperslexFMCWSim('closePlots');
    case 'showFMCWSpectrogram'
        openForPublish('slexFMCWExample/FMCW Spectrogram');
    case 'showDechirpSpectrogram'
        openForPublish('slexFMCWExample/Dechirped Signal Spectrogram');
    case 'showCar'
        openForPublish('slexFMCWExample/Car');
    case 'showSignalProcessing'
        openForPublish('slexFMCWExample/Signal Processing');
    case 'showRangeEstimator'
        openForPublish('slexFMCWExample/Signal Processing/Range Estimator');
    case 'showChannel'
        openForPublish('slexFMCWExample/Channel');
    case 'useTwoRay'
        set_param('slexFMCWExample/Channel','ChannelSelection','Two-ray');
    case 'closeModel'
        close_system('slexFMCWExample',0);
end

function openForPublish(blk)
open_system(blk,'force');
