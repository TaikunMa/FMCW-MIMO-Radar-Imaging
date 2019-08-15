function data = read_lv1_v1(infile)

% Author: Nils Küchler
% created: 9 February 2017
% modified: 9 Feburary 2017, Nils Küchler 

% this function reads the "lv1" files from the first software version. the
% content of this files is split into two parts in the new software
% prudicing lv0 (spectra) and lv1 (moments) files

fid = fopen(infile, 'r', 'l');
    
    %%%%%%%%%%%%%%% header information %%%%%%%%%%%%%%%%
    
    data.filecode = int32(fread(fid,1,'int')); % lv1-file code (=789345), version 1
    data.headerlen = int32(fread(fid,1,'int')); % header length in bytes (not including data.headerlen)
    data.modelno = int32(fread(fid,1,'int')); % =0 singel pol., = 1 dual pol
    data.progno = NaN; % not available in this software version
    
    cc = 0;
    count = 1;
    while cc == 0
        ch(count) = fread(fid,1,'char*1');
        if ch(count) == 0
            data.progname = char(ch); % null terminated strin of chirp program name
            cc = 1;
        else
            count = count + 1;
        end
    end
    clear ch
    
    cc = 0;
    count = 1;
    while cc == 0
        ch(count) = fread(fid,1,'char*1');
        if ch(count) == 0
            data.custname = char(ch); cc = 1; % null terminated string of custumor name
        else
            count = count + 1;
        end
    end
    clear ch cc count
    
    data.n_levels = int32(fread(fid,1,'int')); % number of data.altitudes
    data.range(1:data.n_levels) = single(fread(fid,[1, data.n_levels],'single')); % data.altitude layers
    data.no_chirp_seq = fread(fid,1,'int'); % number of chirp sequences    
    data.range_offsets = int32(fread(fid,[1, data.no_chirp_seq],'int')) + 1; % chirp sequences start index adata.rray in data.altitude layer adata.rray
    data.dr = single(fread(fid,[1, data.no_chirp_seq],'single')); % range resolution adata.rray for chirp sequences
    data.DoppLen = int32(fread(fid,[1, data.no_chirp_seq],'int')); % number of samples in doppler spectra of each chirp sequence
    data.DoppRes = single(fread(fid,[1, data.no_chirp_seq],'single')); % doppler resolution [m/s] for each chirp sequence
    data.DoppMax = single(fread(fid,[1, data.no_chirp_seq],'single')); % maximum unambiguious Doppler vel for each chirp sequence
    data.CalInt = int32(fread(fid,1,'int')); % sample interval for automatic zero calibrations
    data.AntSep = single(fread(fid,1,'single')); % separation of both antena axis (bistatic condifguration) [m]
    data.HPBW = single(fread(fid,1,'single')); % half power beam width [°]
    data.SampDur = single(fread(fid,1,'single')); % sample duration
    data.totsamp = int32(fread(fid,1,'int'));  % total number of samples
        
    %%%%%%%%%%%%%%% start reading data%%%%%%%%%%%%%
    
    % allocate array
    
    data.samplen(1:data.totsamp) = int32(0); % sample length in bytes without data.samplen
    data.time(1:data.totsamp) = int32(0); % time of sample [sec] since 1.1.2001 0:0:0
    data.sampleTms(1:data.totsamp) = single(-999); % milliseconds of sample
    data.rr(1:data.totsamp) = single(-999); % rin rate [mm/h]
    data.rh(1:data.totsamp) = single(-999); % relative humidity [%]
    data.T_env(1:data.totsamp) = single(-999); % environmental temp [K]
    data.pres(1:data.totsamp) = single(-999); % pressure in [hPa]
    data.ff(1:data.totsamp) = single(-999); % windspeed in [km/h]
    data.fff(1:data.totsamp) = single(-999); % winddirection [°]
    data.u(1:data.totsamp) = single(-999); % voltage [V]
    data.Tb(1:data.totsamp) = single(-999); % brightness temperature [K]
    data.lwp(1:data.totsamp) = single(-999); % liquid water path [g/m³]
    data.powIF(1:data.totsamp) = single(-999); % IF power at ADC [µW]
    data.ele(1:data.totsamp) = single(-999); % eleveation angle [°]
    data.az(1:data.totsamp) = single(-999); % azimuth anlge [°]
    data.status(1:data.totsamp) = single(-999); % status flags: 0/1 heater on/off; 0/10 blower on/off
    data.TransPow(1:data.totsamp) = single(-999); % transmitted power [W]
    data.T_trans(1:data.totsamp) = single(-999); % transmitter temperature [K]
    data.T_rec(1:data.totsamp) = single(-999); % receiver temperature [K]
    data.T_pc(1:data.totsamp) = single(-999); % PC temperature [K]
    % reserved(1:3,1:data.totsamp) = single(-999);
    data.Cr(1:data.totsamp) = single(-999); % radar constant
    data.seqstd(1:data.totsamp,1:data.no_chirp_seq) = single(-999); % standard deviation of noise power level in chirp sequences
    
    data.mask(1:data.totsamp,1:data.n_levels) = int8(0); % mask adata.rray of occupied range cells: 0=not occupied, 1=occupied
    data.Ze(1:data.totsamp,1:data.n_levels) = single(-999); % euivalent reflectivity [dBz]
    data.vm(1:data.totsamp,1:data.n_levels) = single(-999);% mean doppler velocity [m/s]
    data.sigma(1:data.totsamp,1:data.n_levels) = single(-999); % spectral width [m/s]
    data.skew(1:data.totsamp,1:data.n_levels) = single(-999); % skewness
    data.kurt(1:data.totsamp,1:data.n_levels) = single(-999); %  kurtosis
    data.spec(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % doppler spectrum
    
    for i = 1:data.totsamp
        data.samplen(i) = fread(fid,1,'int');
        data.time(i) = fread(fid,1,'uint');
        data.sampleTms(i) = fread(fid,1,'int');
        data.rr(i) = fread(fid,1,'single');
        data.rh(i) = fread(fid,1,'single');
        data.T_env(i) = fread(fid,1,'single');
        data.pres(i) = fread(fid,1,'single');
        data.ff(i) = fread(fid,1,'single');
        data.fff(i) = fread(fid,1,'single');
        data.u(i) = fread(fid,1,'single');
        data.Tb(i) = fread(fid,1,'single');
        data.lwp(i) = fread(fid,1,'single');
        data.powIF(i) = fread(fid,1,'single');
        data.ele(i) = fread(fid,1,'single');
        data.az(i) = fread(fid,1,'single');
        data.status(i) = fread(fid,1,'single');
        data.TransPow(i) = fread(fid,1,'single');
        data.T_trans(i) = fread(fid,1,'single');
        data.T_rec(i) = fread(fid,1,'single');
        data.T_pc(i) = fread(fid,1,'single');
        fread(fid,3,'single'); % reserved
        data.Cr(i) = fread(fid,1,'single');
        data.seqstd(i,1:data.no_chirp_seq) = fread(fid,[1, data.no_chirp_seq],'single');
        data.mask(i,1:data.n_levels) = int8(fread(fid,[1, data.n_levels],'char*1'));
        
        for j = 1:data.n_levels
            if data.mask(i,j) == 1
                data.Ze(i,j) = fread(fid,1,'single');
                data.vm(i,j) = fread(fid,1,'single');
                data.sigma(i,j) = fread(fid,1,'single');
                data.skew(i,j) = fread(fid,1,'single');
                data.kurt(i,j) = fread(fid,1,'single');
                
                % find number of cudata.rrent chirp index
                chirp_idx = int32(find(data.range_offsets(2:end) - j > 0,1,'first'));
                if isempty(chirp_idx) % then j is within last chirp
                    chirp_idx = data.no_chirp_seq;
                end
                
                % spectra
                data.spec(i,j,1:data.DoppLen(chirp_idx)) = fread(fid,[1,data.DoppLen(chirp_idx)],'single'); % spectra
                    
            
            end % if
        end % j
        
    end % i
    
    fclose(fid);
    
    
    %%%%%%%%%%%%%%%%%%%%%%% add manually variables included in later software version
    % for actual values for your radar edit preprocessing_nickradar.m
    data.Lat = NaN; % latitude
    data.Lon = NaN; % longitude
    data.freq = NaN; % [GHz]
    data.AntDia = NaN; % [m]
    data.AntG = NaN;
    
    data.DualPol = 0; % 0 = single pol radar, 1 = dual pol radar LDR conf., 2 = dual pol radar STSR mode
    data.CompEna = 0;  % spectral compression flag - no spectra in lv1 file so irrelevant
    data.AntiAlias = NaN; % 0 = Doppler spectra are not anti-aliased, 1 = doppler spectra have been anti-aliased
    data.T_altcount = 0; % number of temperature profile altitude layers
    data.H_altcount = 0; % number of humidity profile altitude layers
    data.T_alt = NaN; % temp prof altitude layers
    data.H_alt = NaN; % hum prof altitude layers
    data.Fr(1:data.n_levels) =  NaN; % range factors
    
    if strcmp(data.progname,'High Res')
        data.SeqAvg = [4096, 3072, 2304, 1792]; % number of averaged chirps within a sequence
        data.SeqIntTime = [0.530, 0.590, 0.731, 0.568]; % effective sequence integration time [sec]
        data.nAvg = data.SeqAvg./data.DoppLen; % number of spectral averages
    elseif strcmp(data.progname,'Doppler 3 sec')
        data.SeqAvg = [4096, 4096, 4096, 9216]; % number of averaged chirps within a sequence
        data.SeqIntTime = [0.338, 0.402, 0.530, 1.769]; % effective sequence integration time [sec]
        data.nAvg = data.SeqAvg./data.DoppLen; % number of spectral averages
    else
        data.SeqAvg = NaN(1,4); % number of averaged chirps within a sequence
        data.SeqIntTime = NaN(1,4); % effective sequence integration time [sec]
        data.nAvg = NaN(1,4); % number of spectral averages
    end
    
    data.QF = NaN;  % quality flag: bit 2 = ADC saturation, bit 3 = spectral width too high, bit 4 = no transm. power leveling    
    data.PNv = NaN; % total IF power in v-pol measured at the ADC input
    data.SLv = NaN; % linear sensitivity limit in Ze units for vertical polarisation
    
    
end % function