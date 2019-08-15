function [error] = momentslv1(info, numdate)

%Error management
error = 0;

%Date info
yyyy = datestr(numdate, 'yyyy');
mm = datestr(numdate, 'mm');
dd = datestr(numdate, 'dd');    
info.outputpath_tree = fullfile(info.outputpath, yyyy, mm, dd);

%Method applied
applied_method = 3;

%Summing up information
path.lv1 = fullfile(info.datapath, yyyy, mm, dd);
files.lv1 = dir(fullfile(path.lv1, info.filetype)); 

%Check if data exists
if isempty(files.lv1)    
    fprintf('%s: files not found.', fullfile(path.lv1, info.filetype))
    error = 1;
    return
end

for h = 1:numel(files.lv1)
    % start with level 1 (lv1) files
    infile = fullfile(path.lv1, files.lv1(h).name);        
    fprintf('Reading level-1 file: %s...\n', infile);
    %output file name
    [~ ,filename,~] = fileparts(files.lv1(h).name);  
    info.filename = filename;  
    
%     outfile = fullfile(info.outputpath, yyyy, mm, dd, sprintf('%s_%s_%s.nc', info.nickradar, info.nickstation, filename));

    if ~info.overwrite 
        typefile = sprintf('%s_*_%s_compact.nc', info.nickradar, filename);
        listFiles = dir(fullfile(info.outputpath_tree, typefile));
        if ~isempty(listFiles)                                        
            fprintf('%s already exists.\n',typefile);                         
            disp('Continue with the next file.'); 
            continue            
        end       
    end
    
    
                    

    % check if LV1 exists                    
    if exist(infile,'file') == 2 % exist by default?
        [reader, lv0filetype] = whichReader(infile);       
         
        if ~isempty(reader)
            data_lv1 = reader.lv1(infile);                    
            data_lv1 = fill2nan_struct(data_lv1,-999.);                  
            data = data_lv1;
           
            % store how moments were calculated
            data.cal_mom = applied_method;
            
            
            %Specific setting or preprocessing are performed in this step.
            funcname = sprintf('preprocessing_%s',info.nickradar);
            funcname = strrep(funcname,'-', '');
            funcpath = fullfile(pwd,'scripts','preprocessing',funcname);
            
            if exist(funcpath, 'file')
                fprintf('Preprocessing %s data...\n', info.nickradar);                   
                setting = str2func(funcname);
                try
                    [data, info] = setting(data, info, lv0filetype);
                catch
                    fprintf('Error executing %s.\n', funcpath);
                    error = 1;
                    return
                end
                fprintf('Preprocessing %s data...done!\n', info.nickradar);
            else
                disp('No preprocessing function found.')
            end
            
            
            disp('Saving data...')    
%             savedata(data, outfile, config);   
            savedata(data, info);    
            disp('Saving data...done!')              
        else
            disp('No way to read this type of file. Please, define a reader in ''whichReader'' function.\n');
            error = 1;            
            return
        end
    else  % file does not exist, calculate moments from spectra
        
        error = 1;
    end        
end
