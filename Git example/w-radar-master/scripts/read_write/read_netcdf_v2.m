function data = read_netcdf_v2(infile)

% Author: Nils Küchler
% created: 9 February 2017
% modified: 9 Feburary 2017, Nils Küchler 

% reads netcdf files that contain joyrad94 data produced with the first
% software version
% adds variables manually that are available with the newsoftware version.
% this is for homogenizing further processing

    vinfo = ncinfo(infile);
    
    varlist = cell(numel(vinfo.Variables),1);    
    for ii = 1:numel(vinfo.Variables)
        varlist{ii,1} = vinfo.Variables(ii).Name;
    end
    
    data = netcdf2struct(infile,varlist);

    
    %%%%%%%%%%%%%%%%%%%%% permute data    
    names = fieldnames(data);
    
    for i = 1:numel(names)
        
        if numel(data.(names{i})) > 1
            s = size(data.(names{i}));
            data.(names{i}) = permute(data.(names{i}),numel(s):-1:1);
        end
        
    end % i
    
    

end % function read_netcdf_v1