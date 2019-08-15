% exmple configuration file to run data processing
% 
% Configuration of the processing script. It includes input and output
% directories of the data, sets radar options (radar location, radar name, 
% contact person), processing options (dealiaising, overwriting of output 
% data) and others.
%
% Processing is done by Raw2l_radar.m (main routine) 
% Example Raw2l_radar('config_joyrad','yyyymmdd')
%
% -------------------------------------------------------------------------
% Settings configuration file
%--------------------------------------------------------------------------

% define inpput data path - structer in selected folder should be 
%                           /yyyy/mm/dd/file-type
config.datapath = '/data/obs/site/nya/joyrad94/l0';

% select input-file-type
% his needs to be a case sensitive match to the file name
%config.filetype = '*nc'; % (older version)
config.filetype = '*lv0'; % (newer version)

% define output path - folder structure will be: /yyyy/mm/dd/*.nc
config.outputpath = '/data/obs/site/nya/joyrad94/l1';

% Instrument nickname:
% - apears in the output file name
% - name has to match the possible preprocessing and postprocessing matlab-
%   function file names
config.nickradar = 'joyrad94';

% station nick name (used for file naming):
% naming convention to use: 3 letters refering to the station measured
% example: JOYCE = joy
config.nickstation = 'joy';   

% height above mean sea level [m] of the instrument platform
% stored in the metadata 
config.MSL = 11;

% further info for output file (metadata for the netcdf-output file)
config.contactperson = 'radarscientist@university.web';
config.processing_script = [mfilename('fullpath') '.m'];

% Debuging option
% 0 - no debugging information given, code does not crash
% 1 - makes check plot in dealising, enables debugging of some functions
config.debuging = 0; 

%Overwrite existing data
% 0 - if output file(s) already exist, no data processing is done
% 1 - overwrite (existing) output file(s) 
config.overwrite = 0; 

% compact-flag: 
% 0 - only general file is created (all metadata information, all flaggs, 
%     all spectra, all moments)
% 1 - only compact file is generated (only moments, some metadata 
%     inforation)
% 2 - both files are gerenrated (both files above are generated)
config.compact_flag = 2;

%Dealias:
% true - dealiasing is applied
% fales - dealiasing not appleied
config.dealias = true;

% moments_cal:
% Note! at the moment (July 2019), only use 2!
% 2 - means spectral moments will be calculated (runs momentslv0-function)
% 3 - means moments are taken from files lv1 if available, (runs momentslv1-function, in 201907 not working)
config.moments2calculate = 2;
