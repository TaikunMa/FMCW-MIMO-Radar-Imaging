function [reader, lv0filetype] = whichReader(infile, config) 

error = 0; 

[~, ~, filetype] = fileparts(infile);

switch filetype
    case {'nc', 'NC', '.nc', '.NC'}
        isnetcdf = 1;
    otherwise    
        isnetcdf = 0;        
        fid = fopen(infile, 'r', 'l');
        if fid == -1
            error = 1;
            fprintf('%s could not be open.', infile);
            return
        end

        code = int32(fread(fid,1,'int'));
        fclose(fid);  
end

if isnetcdf
    
    if strcmp(config.nickradar, 'joyrad94') % software version 1 assumed
        reader.lv0 = str2func('read_netcdf_v1');      
        lv0filetype = 1;
    else
        disp('Radar for netcdf input unknown')
        error = 1; 
    end
else
    if code == 789346 % then it is a binary file that contains variable created with radar software version 2       
    reader.lv0 = str2func('read_lv0_v2');    % copied from joyrad processing script RG 19.3.2018   
    reader.lv1 = str2func('read_lv1_v2'); 
    lv0filetype = 2;
    elseif code == 889346 % then it is a binary file that contains variable created with radar software version 3.5 or later      
        reader.lv0 = str2func('read_lv0_v3');
        reader.lv1 = str2func('read_lv1_v3');     
        lv0filetype = 3;
    elseif code == 889347 % then it is a binary file that contains variable created with radar software version 3.5 or later      
        reader.lv0 = str2func('read_lv0_v3');
        reader.lv1 = str2func('read_lv1_v3');     
        lv0filetype = 3;
    else
        error = 1; 
    end    
end

if error
    reader = [];    
    lv0filetype = [];    
end

if config.debuging
    disp(['RPG file type found: ' num2str(lv0filetype)])
    disp(['Reading function for lv0: '  func2str(reader.lv0)])
end
