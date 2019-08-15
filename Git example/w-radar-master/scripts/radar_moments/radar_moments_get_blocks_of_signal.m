function [block_start, block_end] = radar_moments_get_blocks_of_signal(idx_signal,sv)
    
    % ######### identify serparate blocks
    idx_diff = diff(idx_signal);
    
    s_idx = size(idx_diff);
    if s_idx(1) > s_idx(2)
        idx_diff = idx_diff';
    end

    block_start = find(idx_diff == 1) + 1;
    block_end = find(idx_diff == -1);

    n_start = numel(block_start);
    n_end = numel(block_end);
    
    if n_start == 0 && n_end == 0 % then there is no signal
        block_start = NaN;
        block_end = NaN;
        return
    elseif n_start == 0 % then there is only one block reaching vn
        block_start(1) = 1;
    elseif n_end == 0
        block_end(1) = sv(2);
    end

    if block_end(1) < block_start(1) % then first block start at first bin
        block_start = [1; block_start(:)];
    end

    if block_start(end) > block_end(end) % then last block goes until last bin
        block_end = [block_end(:); sv(2)];
    end
    
    test = size(block_start);
    if test(1) ~= 1
        block_start = block_start';
    end
        
    test = size(block_end);
    if test(1) ~= 1
        block_end = block_end';
    end
    
end % function