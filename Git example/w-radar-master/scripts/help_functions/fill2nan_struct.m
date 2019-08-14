function data = fill2nan_struct(data,fill,varargin)

% input: data (struct or matrix)
%        fill  = fillvalue
%        varargin = can contain fieldnames to skip

if isstruct(data) == 1

    names = fieldnames(data);
    for i = 1:numel(names)
        % check if fillvalue is contained in variable or if variable should
        % be skipped
        if ~isempty(varargin)            
            if isempty(find(data.(names{i}) == fill,1,'first')) || ~isempty(find(strcmp(names{i},varargin), 1))
                continue
            end            
        elseif isempty(find(data.(names{i}) == fill,1,'first'))
            continue
        end
    
        data.(names{i})(data.(names{i}) == fill) = NaN;    
    end

else

    data(data==fill) = NaN;

end
