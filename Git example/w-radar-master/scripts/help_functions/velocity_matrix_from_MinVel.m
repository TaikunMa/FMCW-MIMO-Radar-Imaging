function velmat = velocity_matrix_from_MinVel(velocity, MinVel, range_offsets, Nfft)

% input
%   velocity: velocity array containg doppler vel for each chirp sequence
%       ( no_chirp_seq x max(Nfft) )
%   MinVel: true value of first velocity bin (height x 1) or (height x
%       time)
%   range_offsets: index indicating start of new chirp sequence (1 x
%       no_chirp_seq)
%   Nfft: number of velocity bin in each chirp sequence
%
% output
%   velmat: matrix containing velocity array for each range gate; 
%       if MinVel is 1-D then size(velmat) = (height x max(Nfft))
%       elseif Minvel is 2-D then size(velmat) = (max(Nfft) x height x
%           time)

% get sizes
smv = size(MinVel);
no_chirp_seq = numel(Nfft);

% add a range offset for convience
range_offsets(end+1) = smv(1) + 1;


if smv(2) > 1 % vemat is gonna be 3D
    
    velmat = NaN([max(Nfft), smv]);
    
    for i = 1:smv(2)
        
        % create velocity matrix
        for ii = 1:no_chirp_seq
            
            % get range indexes
            r_idx = range_offsets(ii):range_offsets(ii+1)-1;
            n_r_idx = numel(r_idx);
            
            velmat(:,r_idx,i) = velocity(ii,:)'*ones(1,n_r_idx) + ones(max(Nfft),1)*(MinVel(r_idx,i) - velocity(ii,1))';
            
        end % for ii
        
        
        
    end % for i
    
    
else % create 2D velmat matrix
    
    velmat = NaN([smv(1), max(Nfft)]);
    
    % create velocity matrix
    for ii = 1:no_chirp_seq

        % get range indexes
        r_idx = range_offsets(ii):range_offsets(ii+1)-1;
        n_r_idx = numel(r_idx);
        
        velmat(r_idx,:) = ones(n_r_idx,1)*velocity(ii,:) + (MinVel(r_idx,1) - velocity(ii,1))*ones(1,max(Nfft));
        
    end % for ii
    
end
