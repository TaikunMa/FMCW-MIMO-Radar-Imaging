function helperslexMFSKMultiTargetsSim(command)
% This function helperslexMFSKSim is only in support of slexFMCWExample. It
% may be removed in a future release.

%   Copyright 2014 The MathWorks, Inc.

switch command
    case 'openModel'
        open_system('slexMFSKMultiTargetsExample');
        helperslexMFSKMultiTargetsSim('closePlots');
    case 'runModel'
        sim('slexMFSKMultiTargetsExample');
    case 'showSignalProcessing'
        openForPublish('slexMFSKMultiTargetsExample/Signal Processing');
    case 'showWaveform'
        open_system('slexMFSKMultiTargetsExample/MFSK Waveform');
    case 'closeModel'
        close_system('slexMFSKMultiTargetsExample',0);
end

function openForPublish(blk)
open_system(blk,'force');


