function helperslexFMCWMultiTargetsDOASim(command)
% This function helperslexFMCWMultiTargetsDOASim is only in support of
% slexFMCWMultiTargetsDOAExample. It may be removed in a future release.

%   Copyright 2015 The MathWorks, Inc.

switch command
    case 'openModel'
        open_system('slexFMCWMultiTargetsDOAExample');
        helperslexFMCWMultiTargetsDOASim('closePlots');
    case 'closePlots'
        close_system('slexFMCWMultiTargetsDOAExample/FMCW Spectrogram');
        close_system('slexFMCWMultiTargetsDOAExample/Dechirped Signal Spectrogram');
    case 'runModel'
        sim('slexFMCWMultiTargetsDOAExample');
        helperslexFMCWMultiTargetsDOASim('closePlots');
    case 'showArray'
        openSensorTabForPublish('slexFMCWMultiTargetsDOAExample/Narrowband Transmit Array');
    case 'showSignalProcessing'
        openForPublish('slexFMCWMultiTargetsDOAExample/Signal Processing');
    case 'closeModel'
        close_system('slexFMCWMultiTargetsDOAExample',0);
end

function openForPublish(blk)
open_system(blk,'force');

function openSensorTabForPublish(blk)
open_system(blk);
% dlg = DAStudio.ToolRoot.getOpenDialogs.find('dialogTag','phased.Radiator');
% imd = DAStudio.imDialog.getIMWidgets(dlg);
% tabbar = imd.find('-isa','DAStudio.imTabBar');
% tabs = tabbar.find('-isa','DAStudio.imTab');
% tabbar.setTab(find(strcmp('SectionGroup2',get(tabs,'Tag')))-1);

