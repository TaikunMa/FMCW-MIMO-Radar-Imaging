function [] = savedata(data, config)

% finding output filename moved to it's own function findoutfilename - RG

% quality flag converted to float
specsize = size(data.spec);
tempvar = data.QualFlag;
data.QualFlag = zeros(specsize(1),specsize(2));
for ii = 1:specsize(1)
    for jj = 1:specsize(2)
        data.QualFlag(ii,jj) = bin2dec(num2str(tempvar(ii,jj,:)));
    end
end
   
% write full file
if config.compact_flag ~=1
    if exist(config.outfile,'file')
        delete(config.outfile);
    end
    
    [pathstr,~ ,~] = fileparts(config.outfile);
    if ~exist(pathstr,'dir')
        mkdir(pathstr);
    end

    disp(['Writing file ' config.outfile])
    write_joyrad94_data_2_nc(data,config.outfile, config.contactperson, config.processing_script);  
end


% write compact file
if config.compact_flag~=0
    if exist(config.outfile2,'file')
        delete(config.outfile2);
    end
    
    [pathstr,~ ,~] = fileparts(config.outfile2);
    if ~exist(pathstr,'dir')
        mkdir(pathstr);
    end
    
    disp(['Writing file ' config.outfile2])
    write_joyrad94_data_2_nc_compact(data,config.outfile2, config.contactperson, config.processing_script);
end
