function data = netcdf2struct(filename,varargin)

% reads netcdf files and returns a struct containing all selevted data in
% varargin

% input:
%   filename
%   varargin: can ne a cell array containing lists of variables or several
%   variables, if varargin is empty all variables are read in

% output:
%   data: contains variables in varargin

%%%% check existence of file
if ne(exist(filename,'file'),2)
    disp('file does not exist');
    data = -999.;
    return
end

%**** open file
ncid = netcdf.open(filename,'NC_NOWRITE');

if ~isempty(varargin)
    
    for i = 1:numel(varargin)

        if iscell(varargin{i})

            for ii = 1:numel(varargin{i})            
                id = netcdf.inqVarID(ncid,varargin{i}{ii});
                data.(varargin{i}{ii}) = netcdf.getVar(ncid,id);
            end

        else
            id = netcdf.inqVarID(ncid,varargin{i});
            data.(varargin{i}) = netcdf.getVar(ncid,id);       

        end

    end
    
else
    
    info = ncinfo(filename);
    for ii = 1:numel(info.Variables)
         id = netcdf.inqVarID(ncid,info.Variables(ii).Name);
         data.(info.Variables(ii).Name) = netcdf.getVar(ncid,id);
    end
    
end
    

%***** close file
netcdf.close(ncid);