function [spec_chain, status_flag] = dealias_spectra_concetenate_spectra(vm_guess, spec, vn, ii, next_chirp, Nfft)

% input:
%   spec: spectra of column
%   vn: nyquist velocity of considered chirp sequence
%   ii: index of considered bin
%   next_chirp: distance to next chirp
%   vm_guess: initial guess of mean doppler velocity of neighbouring bin
%   delta: distance to chirp sequence border
%
% output:
%   spec_chain: chain of 5 concetenated spectra for deliasing
%   status_flag == '000' if dealiasing works fine, '010' if boundaries are
%   exceeded


% delta = ii - next_chirp
status_flag = '0000';

delta = ii - next_chirp;

if delta == -3 % then second upper bin is in new chirp sequence
    
    % check if double aliasing might have occure
    if vm_guess < -11/4*vn % if yes dealiasing correctly for motion towards the radar is not possible anymore since no spectrum at expected velocities is avaiable
        status_flag(2) = '1';
    end
    
    spec_chain = [spec(ii+2,1:Nfft), spec(ii+2,1:Nfft), spec(ii+1,1:Nfft), spec(ii,1:Nfft), spec(ii-1,1:Nfft), spec(ii-2,1:Nfft), spec(ii-3,1:Nfft)];
    
    % check if neighbouring spectra contain signal, else dublicate
    % neighbouring spectrum
    if isnan(spec(ii+1,1))
        spec_chain(2*Nfft+1:3*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii+2,1))
        spec_chain(Nfft+1:2*Nfft) = spec_chain(2*Nfft+1:3*Nfft);
        spec_chain(1:Nfft) = spec_chain(2*Nfft+1:3*Nfft);
    end

    if isnan(spec(ii-1,1))
        spec_chain(4*Nfft+1:5*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii-2,1))
        spec_chain(5*Nfft+1:6*Nfft) = spec_chain(4*Nfft+1:5*Nfft);
    end
    if isnan(spec(ii-3,1))
        spec_chain(6*Nfft+1:end) = spec_chain(5*Nfft+1:6*Nfft);
    end
    

elseif delta == -2 % then second upper bin is in new chirp sequence
    
    % check if double aliasing might have occure
    if vm_guess < -11/4*vn % if yes dealiasing correctly for motion towards the radar is not possible anymore since no spectrum at expected velocities is avaiable
        status_flag(2) = '1';
    end
    
    spec_chain = [spec(ii+1,1:Nfft), spec(ii+1,1:Nfft), spec(ii+1,1:Nfft), spec(ii,1:Nfft), spec(ii-1,1:Nfft), spec(ii-2,1:Nfft), spec(ii-3,1:Nfft)];
    
    % check if neighbouring spectra contain signal, else dublicate
    % neighbouring spectrum
    if isnan(spec(ii+1,1))
        spec_chain(1:Nfft)         = spec(ii,1:Nfft);
        spec_chain(Nfft+1:2*Nfft)  = spec(ii,1:Nfft);
        spec_chain(2*Nfft+1:3*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii-1,1))
        spec_chain(4*Nfft+1:5*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii-2,1))
        spec_chain(5*Nfft+1:6*Nfft) = spec_chain(4*Nfft+1:5*Nfft);
    end
    if isnan(spec(ii-3,1))
        spec_chain(6*Nfft+1:end) = spec_chain(5*Nfft+1:6*Nfft);
    end
    
    
elseif delta == -1 % then next bin is in new chirp sequence
    
    % check if aliasing into upper bin might have occurred
    if vm_guess < -3/4*vn % if yes dealiasing correctly for motion towards the radar is not possible anymore since no spectrum at expected velocities is avaiable
        status_flag(2) = '1';
    end
    
    % else aliasing into lower bins can be corrected
    
    % create spec_chain, triplicate spectrum of current bin
    spec_chain = [spec(ii,1:Nfft), spec(ii,1:Nfft), spec(ii,1:Nfft), spec(ii,1:Nfft) spec(ii-1,1:Nfft), spec(ii-2,1:Nfft), spec(ii-3,1:Nfft)];
    
    % check if neighbouring spectra contain signal, else dublicate
    % neighbouring spectrum
    if isnan(spec(ii-1,1))
        spec_chain(4*Nfft+1:5*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii-2,1))
        spec_chain(5*Nfft+1:6*Nfft) = spec_chain(4*Nfft+1:5*Nfft);
    end
    if isnan(spec(ii-3,1))
        spec_chain(6*Nfft+1:end) = spec_chain(5*Nfft+1:6*Nfft);
    end
    
elseif delta == 0 % two lower bins are in the previous chirp_sequence
    
    % check if aliasing into lower bins occured
    if vm_guess > 3/4*vn % then dealiasing is not possible but use spectra from upper (dealiased) bin
        status_flag(2) = '1';
    end
    
    % else dealias spectrum:
    
    % create spec_chain, triplicate spectrum of current bin
    spec_chain = [spec(ii+3,1:Nfft), spec(ii+2,1:Nfft), spec(ii+1,1:Nfft), spec(ii,1:Nfft), spec(ii,1:Nfft), spec(ii,1:Nfft), spec(ii,1:Nfft)];
    
    % check if neighbouring spectra contain signal, else dublicate
    % neighbouring spectrum
    if isnan(spec(ii+1,1))
        spec_chain(2*Nfft+1:3*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii+2,1))
        spec_chain(Nfft+1:2*Nfft) = spec_chain(2*Nfft+1:3*Nfft);
    end
    if isnan(spec(ii+3,1))
        spec_chain(1:Nfft) = spec_chain(Nfft+1:2*Nfft);
    end
    
elseif delta == 1 % second lower bin is pervious chirp sequence
    
    % check if double aliasing into lower bins occured
    if vm_guess > 11/4*vn % then dealiasing is not possible but use spectra from upper (dealiased) bin
        status_flag(2) = '1';
    end
    
    % create spec_chain, dublicate spectrum of lower bin
    spec_chain = [spec(ii+3,1:Nfft), spec(ii+2,1:Nfft), spec(ii+1,1:Nfft), spec(ii,1:Nfft), spec(ii-1,1:Nfft), spec(ii-1,1:Nfft), spec(ii-1,1:Nfft)];
    
    % check if neighbouring spectra contain signal, else dublicate
    % neighbouring spectrum
    if isnan(spec(ii-1,1))
        spec_chain(4*Nfft+1:5*Nfft) = spec(ii,1:Nfft);
        spec_chain(5*Nfft+1:6*Nfft) = spec(ii,1:Nfft);
        spec_chain(6*Nfft+1:end)    = spec(ii,1:Nfft);
    end
    if isnan(spec(ii+1,1))
        spec_chain(2*Nfft+1:3*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii+2,1))
        spec_chain(Nfft+1:2*Nfft) = spec_chain(2*Nfft+1:3*Nfft);
    end
    if isnan(spec(ii+3,1))
        spec_chain(1:Nfft) = spec_chain(Nfft+1:2*Nfft);
    end
    
elseif delta == 2 % third lower bin is pervious chirp sequence
    
    % check if double aliasing into lower bins occured
    if vm_guess > 11/4*vn % then dealiasing is not possible but use spectra from upper (dealiased) bin
        status_flag(2) = '1';
    end
    
    % create spec_chain, dublicate spectrum of lower bin
    spec_chain = [spec(ii+3,1:Nfft), spec(ii+2,1:Nfft), spec(ii+1,1:Nfft), spec(ii,1:Nfft), spec(ii-1,1:Nfft), spec(ii-2,1:Nfft), spec(ii-2,1:Nfft)];
    
    % check if neighbouring spectra contain signal, else dublicate
    % neighbouring spectrum
    if isnan(spec(ii-1,1))
        spec_chain(4*Nfft+1:5*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii-2,1))
        spec_chain(5*Nfft+1:6*Nfft) = spec_chain(4*Nfft+1:5*Nfft);
        spec_chain(6*Nfft+1:end)    = spec_chain(4*Nfft+1:5*Nfft);
    end
    if isnan(spec(ii+1,1))
        spec_chain(2*Nfft+1:3*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii+2,1))
        spec_chain(Nfft+1:2*Nfft) = spec_chain(2*Nfft+1:3*Nfft);
    end    
    if isnan(spec(ii+3,1))
        spec_chain(1:Nfft) = spec_chain(Nfft+1:2*Nfft);
    end
    
else % create spectral array concatenating five spectra
    
    spec_chain = [spec(ii+3,1:Nfft), spec(ii+2,1:Nfft), spec(ii+1,1:Nfft), spec(ii,1:Nfft), spec(ii-1,1:Nfft), spec(ii-2,1:Nfft), spec(ii-3,1:Nfft)];
    
    % check if neighbouring spectra contain signal, else dublicate
    % neighbouring spectrum
    if isnan(spec(ii-1,1))
        spec_chain(4*Nfft+1:5*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii-2,1))
        spec_chain(5*Nfft+1:6*Nfft) = spec_chain(4*Nfft+1:5*Nfft);
    end
    if isnan(spec(ii-3,1))
        spec_chain(6*Nfft+1:end) = spec_chain(5*Nfft+1:6*Nfft);
    end
    if isnan(spec(ii+1,1))
        spec_chain(2*Nfft+1:3*Nfft) = spec(ii,1:Nfft);
    end
    if isnan(spec(ii+2,1))
        spec_chain(Nfft+1:2*Nfft) = spec_chain(2*Nfft+1:3*Nfft);
    end
    if isnan(spec(ii+3,1))
        spec_chain(1:Nfft) = spec_chain(Nfft+1:2*Nfft);
    end
    
end