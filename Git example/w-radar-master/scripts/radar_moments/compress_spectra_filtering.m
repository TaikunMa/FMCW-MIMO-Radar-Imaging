function spec = compress_spectra_filtering(spec, Nbin)
% function to remove all spectral bin-blocks with less than Nbin following
% the procedure that is applied for non-compressed spectra before
% calculating moments
% 
% LP & RG 31.7.2019

ss = size(spec);

for ii = 1:ss(1)
    for jj = 1:ss(2)
        
        if all((isnan(spec(ii,jj,:)))) % no data, no check needed
            continue
        end
        
        idx = ~isnan(spec(ii,jj,:));
        
        % determine blocks of consecutive bins
        [block_start, block_end] = radar_moments_get_blocks_of_signal(idx,[1, ss(3)]);
    
        if isnan(block_start)
            spec(ii,jj,:) = NaN;
            continue
        end
    
        % determine size of these blocks
        blocksizes = block_end - block_start + 1;

        % consider only blocks with consecutive bins larger than X-1
        
        for bb = 1:length(blocksizes)
            if blocksizes(bb) < Nbin
                spec(ii,jj,block_start(bb):block_end(bb)) = NaN;
            end % fi
            
        end % bb
    
    end
end