function cont_mat = spike_filter_joy94_high_res_mode_v2(spec) %, noise, range_offsets, Nfft, varargin)

% input:
%   spec: linear Doppler spectra of full column (height x Nfft)
    % ##### only needed when steps 2 and 3 are enabled:
    %   noise: struct containing fields meannoise and peaknoise
    %   range_offsets: indexes indicating start of new chirp sequence
    %   Nfft: numvber of velocity bins in each chirp sequence
    %   varargin: index in spec where contamination is expected
%
% output:
%   cont_mat: contaminated bins; if there is no cloud but contamination
%   then all entries are true

% the following rangebins are known to contain contamination
% idx = [224, 225, 765, 766];

% 1) check if there is signal above/below; if not then just set to NAN


ss = size(spec);

% create output matrix
cont_mat = false(ss);

% flag empty range bins
flag = isnan(spec);

for ii = 1:ss(2)


    if all(flag(221:223, ii)) && all(flag(226:227, ii)) && (flag(224, ii) == false || flag(225, ii) == false) % check where signal occurs

        % 1) ###################
        if flag(224, ii) == false
            cont_mat(224,ii) = true;
        end

        if flag(225, ii) == false
            cont_mat(225, ii) = true;
        end

    end

    % check if neighbouring bins are occupied
    if all(flag(762:764, ii)) && all(flag(767:769, ii)) && (flag(765, ii) == false || flag(766, ii) == false) % check where signal occurs

        % 1) ###################    
        if flag(765, ii) == false
            cont_mat(765, ii) = true;
        end

        if flag(766, ii) == false
            cont_mat(766, ii) = true;
        end

    end
    
end






end % funtction