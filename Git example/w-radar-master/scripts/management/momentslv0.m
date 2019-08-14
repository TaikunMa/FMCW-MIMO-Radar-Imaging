function [error] = momentslv0(config, numdate)


%Error management
error = 0;

%Date info
yyyy = datestr(numdate, 'yyyy');
mm = datestr(numdate, 'mm');
dd = datestr(numdate, 'dd');    
config.outputpath_tree = fullfile(config.outputpath, yyyy, mm, dd);

%Summing up configrmation
path.lv0 = fullfile(config.datapath, yyyy, mm, dd);
files.lv0 = dir(fullfile(path.lv0, config.filetype)); 

%First, try to find binary data
if isempty(files.lv0)    
    fprintf('%s: files not found.', fullfile(path.lv0, config.filetype))
    error = 1;
    return

else
       
    disp('Running code...')
    for h = 1:numel(files.lv0)
        % start with level 0 (lv0) files
        infile = fullfile(path.lv0, files.lv0(h).name);        
        fprintf('Start processing with %s\n', infile);
        
        
        % i) check if output file already exist
        % output file name
        [config] = findoutfilename(config, files.lv0(h).name);

        if ~config.overwrite
            switch config.compact_flag
                case 0 % general file
                    if ~isempty(dir(config.outfile))                                                             
                        disp('Output file already exist. Continue with the next file.'); 
                        continue            
                    end

                case 1  % compact file
                    
                    if ~isempty(dir(config.outfile2))                                                             
                        disp('Output file already exist. Continue with the next file.'); 
                        continue            
                    end
              
                case 2  % both
                   
                    if ~(isempty(dir(config.outfile)) || isempty(dir(config.outfile2))) 
                        disp('Output files already exist. Continue with the next file.'); 
                        continue            
                    end
                    
            end
        end
                       
        %Input confirmation
        config.path = path;        
        applied_method = 0;        
        
        % ii) Reading input data
        
        %Determine the program to read the radar file
        [reader, filetype] = whichReader(infile, config);             
        if isempty(reader)
            disp('No way to read this type of file. Please, define a reader in ''whichReader'' function.\n');
            error = 1;
            return
        end   

        %Reading the data
        disp('Loading data...');
        data = reader.lv0(infile);
        disp('Loading data...done!');
        
        %If there are samples, the process starts, otherwise it follows
        %with another file
        if data.totsamp ~= 0 
            fprintf('%d samples found in %s\n', data.totsamp, infile);
            
            
            % iii) Additional variables added into "data" and missing values set to NaN.
            disp('Completing data structure...');
            
            if config.debuging % for debugging, want to have the code crash
                [data] = setting_data(data, config);
                disp('Completing data structure...done!');
            else
                try
                    [data] = setting_data(data, config);
                    disp('Completing data structure...done!');
                catch 
                    disp('Completing data structure...Error!!');
                    error = 1;
                    return
                end
            end                        
            
            % iv) Radar specific settings or preprocessing
            funcname = sprintf('preprocessing_%s',config.nickradar);
            funcname = strrep(funcname,'-', ''); % dash not allowed in function name
            funcpath = fullfile(pwd,'scripts','preprocessing',funcname);
            
            if exist(funcpath, 'file')
                fprintf('Preprocessing %s data...\n', config.nickradar);                   
                setting = str2func(funcname);
                try
                    [data, config] = setting(data, config, filetype);
                catch
                    fprintf('Error executing %s.\n', funcpath);
                    error = 1;
                    return
                end
                fprintf('Preprocessing %s data...done!\n', config.nickradar);
            else
                disp('No preprocessing function found.')
            end
                

            % v) Dealising and calculating moments
            
            % for compressed spectra, remove all spectral bin-blocks with
            % less than Nbin
            if data.compress_spec
                Nbin = 5;
                data.spec = compress_spectra_filtering(data.spec, Nbin);
                
                if data.DualPol == 1
                    data.spec_hv = compress_spectra_filtering(data.spec_hv, Nbin);
                
                elseif data.DualPol == 2
                    disp('Not programmed yet')
                end
            end
            
            if config.dealias  % If the user wants to do it
                
                if data.AntiAlias
                    disp('Dealising already applied in RPG software.')
                    disp('    -> Currently this is not a working option - 18.7.2019');  
                    applied_method = 2;
                    
                     %Retrieval of moments
                    disp('Radar moments are now calculated from spectra dealiased by RPG software.')
                    disp('   -> data output for higher moments definitely not correct - 18.7.2019')
                    data = moments_retrieval(data);
                    
                else 
                
                    disp('Dealising Doppler spectral velocity...');
                    % dealias the spectra and calculates moments from corrected spectra
                    data = dealising(data); 
                    applied_method = 1;
                    disp('Dealising Doppler spectral velocity...done!');
                    
                end    
            else
                disp('No Dealising because of the user settings.');                           
                
                %Retrieval of moments
                disp('Radar moments are now calculated from spectra that has not been dealiased.')
                data = moments_retrieval(data);
                
            end

            %Adjusting data.mask
            data.mask(:,:) = 0;
            data.mask(~isnan(data.Ze)) = 1;

            %set all not occupied values to NaN do decrease data
            idx = data.mask == 0;
            data.MinVel(idx) = NaN;
            data.MinVel_Correction(idx) = NaN;
            data.AliasStatus(idx) = NaN;
            data.Aliasmask(idx) = NaN;

            if config.debuging
                %Plots of the mean Doppler velocity
                dealias_spectra_plot_control_figures(data)
            end
        else
            fprintf('%s is empty.\n', infile);
            error = 1;
            return
        end        
        
        % store how moments were calculated
        data.cal_mom = applied_method;
        
        
        % Specific setting or postprocessing are performed in this step.
        % (corrections to Ze for older software versions etc)
        funcname = sprintf('postprocessing_%s',config.nickradar);
        funcname = strrep(funcname,'-', ''); % dash not allowed in function name
        funcpath = fullfile(pwd,'scripts','postprocessing',funcname);

        if exist(funcpath, 'file')
            fprintf('Postprocessing %s data...\n', config.nickradar);                   
            setting = str2func(funcname);
            
             if config.debuging % for debugging, want to have the code crash
                [data, config] = setting(data, config);
                fprintf('Postprocessing %s data...done!\n', config.nickradar);
             else
                 try
                     [data, config] = setting(data, config);
                 catch
                     fprintf('Error executing %s.\n', funcpath);
                     error = 1;
                     return
                 end
             end
             fprintf('Postprocessing %s data...done!\n', config.nickradar);
        else
            disp('No postprocessing function found.')
        end
        

        disp('Saving data...')    
        savedata(data, config);    
        disp('Saving data...done!')   
        
        %return
    end % h = 1:numel(files)    
        
end

 
