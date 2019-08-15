function output = radar_chirps(spec, velocity, range_offsets)

% ########### get NFFt in each chirp sequence
Nfft = sum(~isnan(velocity),2);

for ii = 1:numel(range_offsets)-1  
    tempspec = spec(range_offsets(ii):range_offsets(ii+1)-1,1:Nfft(ii));
    tempvelocity = velocity(ii,1:Nfft(ii));
    % Calculate radar moments
    tempoutput = radar_moments_retrieval(tempspec, tempvelocity, 'kurt');       
    
    names = fieldnames(tempoutput);    
    for iii = 1:numel(names)        
        output.(names{iii})(range_offsets(ii):range_offsets(ii+1)-1,1) = tempoutput.(names{iii});        
    end % iii    
end % ii

