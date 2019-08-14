function [] = Raw2l1_radar(infopath, varargin)
% Create netcdf4 files from lv0 and/or lv1 files from RPWG FMCW radars.
% For more information see README.md
% 
% The program was first created by Nils Küchler in 2018. The code was 
% restructured and partly updated in 2019 by Juan Antonio Bravo Aranda and 
% Rosa Gierens.
% 
% Intputs:
%   - Infopath: path of the configuration file
%   - Varargin: 0=today and yesterday; 1=specific date [format 'yyyymmdd'];
%               2=period with dateini and dateend [both with format 'yyyymmdd']-

% Add functions in subfolders
addpath(genpath('./scripts/'))

switch (nargin - 1) % configures the time period to be processed
    
    case -1
        disp('Configuration file name needs to be given as input.');
        return
    case 0 % no dates given as input
        dateend = floor(now);
        dateini = dateend-1; 
    case 1 % 1 input date given
        dateini=datenum(varargin{1}, 'yyyymmdd');
        dateend = dateini;
    case 2 % time interval given
        dateini = datenum(varargin{1}, 'yyyymmdd');
        dateend = datenum(varargin{2}, 'yyyymmdd');
    otherwise
        disp('Number of inputs exceed.');
        return
end

%Load config information
try
    run(infopath);
catch
    disp('Impossible to read configuration file.')
    return
end

%Run code for each date
for tmpdate = dateini:dateend

    fprintf('Launching raw2l1_radar for %s...\n', datestr(tmpdate, 'yyyymmdd'));
    if config.moments2calculate == 2        
        disp('Retrieving radar moments from level-0 files.');
        error = momentslv0(config, tmpdate);                    
        if ~error
            disp('Retrieving radar moments from level-0 files... done!');
        end           
        
    elseif config.moments2calculate == 3
        disp('Reading radar moments from RPG level-1 files...');
        disp('This does not work currently, sorry - RG')
        return
%         error = momentslv1(config, tmpdate);
%         if ~error
%             disp('Reading radar moments from level-1 files...done!');
%         end
    end  
    
    if ~error
        fprintf('Launching raw2l1_radar for %s...done!\n', datestr(tmpdate, 'yyyymmdd'));
    end
end 
disp('End of raw2l1_radar');
