function [config] = findoutfilename(config, filein)
% Function to find output file name. Moved here from savedata.
% RG 27.6.2019

[~, filename, ~] = fileparts(filein); 
config.filename = filename; 

%Remove from filename duplicated info
filename = strrep(config.filename,config.nickradar, '');
filename = strrep(filename,config.nickstation, '');


switch config.compact_flag
    case 0
        outfile = fullfile(config.outputpath_tree, sprintf('%s_%s_%s.nc', config.nickradar, config.nickstation, filename));
    case 1
        outfile2 = fullfile(config.outputpath_tree, sprintf('%s_%s_%s_compact.nc', config.nickradar, config.nickstation, filename));
    case 2
        outfile = fullfile(config.outputpath_tree, sprintf('%s_%s_%s.nc', config.nickradar, config.nickstation, filename));
        outfile2 = fullfile(config.outputpath_tree, sprintf('%s_%s_%s_compact.nc', config.nickradar, config.nickstation, filename));
end



if exist('outfile', 'var')

    while strfind(outfile, '__')
        outfile = strrep(outfile,'__', '_');
    end

    config.outfile = outfile;
end



if exist('outfile2', 'var')
    
    while strfind(outfile2, '__')
        outfile2 = strrep(outfile2,'__', '_');
    end

    config.outfile2 = outfile2;
end
