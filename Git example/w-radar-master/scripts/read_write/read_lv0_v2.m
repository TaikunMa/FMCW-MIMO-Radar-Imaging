function data = read_lv0_v2(infile)

% reads binary files from lv0 of joyrad94 and return data in a struct
% Author: Nils Küchler
% created: 9 February 2017
% modified: 9 Feburary 2017, Nils Küchler 

%%%%%%%%%%%%%%%% open file
    fid = fopen(infile, 'r', 'l');
    
    if fid == -1
        disp(['error opening' infile])
        return
    end
    
    %%%%%%%%%%%%%%% read header information %%%%%%%%%%%%%%%%
    
    data.filecode = int32(fread(fid,1,'int')); % lv1-file code
    data.headerlen = int32(fread(fid,1,'int')); % header length in bytes (not including headerlen)
    data.progno = int32(fread(fid,1,'int')); % program number, as definded in the host-pc software
    data.modelno = int32(fread(fid,1,'int')); % =0 singel pol., = 1 dual pol
    
    cc = 0;
    count = 1;
    while cc == 0
        ch(count) = fread(fid,1,'char*1');
        if ch(count) == 0
            data.progname = char(ch); % null terminated string of chirp program name
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
    
    data.freq = single(fread(fid,1,'single')); % radar frequency [GHz]
    data.AntSep = single(fread(fid,1,'single')); % antenna separation [m]
    data.AntDia = single(fread(fid,1,'single')); % antenna diameter [m]
    data.AntG = single(fread(fid,1,'single')); % linear antenna gain
    data.HPBW = single(fread(fid,1,'single')); % half power beam width [°]
    data.C = single(fread(fid,1,'single')); % radar constant, defined by eq. (2.1.5) radar_manual_v2
    data.DualPol = int8(fread(fid,1,'char*1')); % 0 = single pol radar, 1 = dual pol radar LDR conf., 2 = dual pol radar STSR mode
    data.CompEna = int8(fread(fid,1,'char*1')); % spectral compression flag: 0 = not compressed, 1 = spectra compressed, 2 = spectra compressed and spectral polarimetric variables stored in the file
    data.AntiAlias = int8(fread(fid,1,'char*1')); % 0 = Doppler spectra are not anti-aliased, 1 = doppler spectra have been anti-aliased
    data.SampDur = single(fread(fid,1,'single')); % sample duration [sec]
    data.Lat = single(fread(fid,1,'single')); % GPS latitude
    data.Lon = single(fread(fid,1,'single')); % GPS longitude
    data.CalInt = int32(fread(fid,1,'int')); % period of automatic zero calibrations in number of samples
    data.n_levels = int32(fread(fid,1,'int')); % number of radar altitude layers
    data.T_altcount = int32(fread(fid,1,'int')); % number of temperature profile altitude layers
    data.H_altcount = int32(fread(fid,1,'int')); % number of humidity profile altitude layers
    data.no_chirp_seq = fread(fid,1,'int'); % number of chirp sequences
    data.range(1:data.n_levels) = single(fread(fid,[1, data.n_levels],'single')); % radar altitude layers
    data.T_alt(1:data.T_altcount) = single(fread(fid,[1, data.T_altcount],'single')); % temp prof altitude layers
    data.H_alt(1:data.H_altcount) = single(fread(fid,[1, data.H_altcount],'single')); % hum prof altitude layers
    data.Fr(1:data.n_levels) = int32(fread(fid,[1, data.n_levels],'int')); % range factors
    data.DoppLen = int32(fread(fid,[1, data.no_chirp_seq],'int')); % number of samples in doppler spectra of each chirp sequence
    data.range_offsets = int32(fread(fid,[1, data.no_chirp_seq],'int')) + 1; % chirp sequences start index array in altitude layer array
    data.SeqAvg = int32(fread(fid,[1, data.no_chirp_seq],'int')); % number of averaged chirps within a sequence
    data.SeqIntTime = single(fread(fid,[1, data.no_chirp_seq],'single')); % effective sequence integration time [sec]
    data.dr = single(fread(fid,[1, data.no_chirp_seq],'single')); % chirp sequence range resolution [m]
    data.DoppMax = single(fread(fid,[1, data.no_chirp_seq],'single')); % maximum unambiguious Doppler vel for each chirp sequence
    data.totsamp = int32(fread(fid,1,'int'));  % total number of samples
    
    % ################################# header ends
       
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% allocate arrays
    
    data.samplen(1:data.totsamp) = int32(0); % sample length in bytes without samplen
    data.time(1:data.totsamp) = uint32(0); % time of sample [sec] since 1.1.2001 0:0:0
    data.sampleTms(1:data.totsamp) = int32(0); % milliseconds of sample
    data.QF(1:data.totsamp) = int8(0); % quality flag: bit 4 = ADC saturation, bit 3 = spectral width too high, bit 2 = no transm. power leveling, get bits using dec2bin()
    data.RR(1:data.totsamp) = single(-999); % rin rate [mm/h]
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
    % data.reserved(1:3,1:data.totsamp) = single(-999);
    % data.Tprof(1:data.T_altcount,1:data.totsamp) = single(-999); % temperature profile
    % data.Qprof(1:data.H_altcount,1:data.totsamp) = single(-999); % abs hum profile
    % data.RHprof(1:data.H_altcount,1:data.totsamp) = single(-999); % rel hum profile
    data.PNv(1:data.totsamp,1:data.n_levels) = single(-999); % total IF power in v-pol measured at the ADC input
    data.SLv(1:data.totsamp,1:data.n_levels) = single(-999); % linear sensitivity limit in Ze units for vertical polarisation
    data.spec(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % vertical pol doppler spectrum linear units
    if data.DualPol > 0
        data.PNh(1:data.totsamp,1:data.n_levels) = single(-999); % total IF power in h-pol measured at ADT unput
        data.SLh(1:data.totsamp,1:data.n_levels) = single(-999); % linear sensitivity limit in Ze units for horizontal polarisation
        data.spec_h(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % hor pol doppler spectrum linear units
        data.spec_covRe(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % real part of covariance spectrum
        data.spec_covIm(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % imaginary part of covariance spectrum
    end      
    data.mask(1:data.totsamp,1:data.n_levels) = int8(0); % data.mask array of occupied range cells: 0=not occupied, 1=occupied
    
    if data.CompEna == 2 && data.DualPol > 0
        data.d_spec(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % spectral differential reflectivity [dB]
        data.CorrCoeff(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % rho_hv, spectral corellation coefficient [0,1]
        data.DiffPh(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % spectral differential phase [rad]
    end
    
    if data.DualPol == 2 && data.CompEna == 2
        data.SLDR(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % compressed spectral slanted LDR [dB]
        data.SCorrCoeff(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % compressed spectral slanted correlation coefficient [0,1]
        if data.CompEna == 2
            data.KDP(1:data.totsamp,1:data.n_levels) = single(-999); % specific differential phase shift [rad/km]
            data.DiffAtt(1:data.totsamp,1:data.n_levels) = single(-999); % differential attenuation [dB/km]             
        end % data.CompEna        
    end % data.DualPol
    
    if data.CompEna > 0
        data.VNoisePow_mean(1:data.totsamp,1:data.n_levels) = single(-999); % integrated Doppler spectrum noise power in v-pol [Ze]
        if data.DualPol > 0
            data.HNoisePow_mean(1:data.totsamp,1:data.n_levels) = single(-999); % integrated Doppler spectrum noise power in h-pol [Ze]
        end
    end
                    
    if data.AntiAlias == 1
        data.Aliasmask(1:data.totsamp,1:data.n_levels) = int8(0); % data.mask array if aliasing has been applied: 0=not apllied, 1=apllied
        data.MinVel(1:data.totsamp,1:data.n_levels) = single(-999.); % minimum velocity in Doppler spectrum [m/s]
    end
    
    
    %############################## end allocating
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% start reading the rest of the file
    for i = 1:data.totsamp
        
        data.samplen(i) = fread(fid,1,'int');
        data.time(i) = fread(fid,1,'uint');
        data.sampleTms(i) = fread(fid,1,'int');
        data.QF(i) = int8(fread(fid,1,'char*1'));
        data.RR(i) = fread(fid,1,'single');
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
        data.reserved(i,1:3) = fread(fid,3,'single'); % reserved
        fread(fid,data.T_altcount,'single'); % temp prof
        fread(fid,data.H_altcount,'single'); % abs hum prof
        fread(fid,data.H_altcount,'single'); % rel hum prof
        
        data.PNv(i,1:data.n_levels) = fread(fid,[1, data.n_levels],'single');
        if data.DualPol > 0
            data.PNh(i,1:data.n_levels) = fread(fid,[1, data.n_levels],'single');
        end
            
        data.SLv(i,1:data.n_levels) = fread(fid,[1, data.n_levels],'single');
        if data.DualPol > 0
            data.SLh(i,1:data.n_levels) = fread(fid,[1, data.n_levels],'single');
        end
        
        data.mask(i,1:data.n_levels) = int8(fread(fid,[1, data.n_levels],'char*1'));        
        
        for j = 1:data.n_levels
                        
            if data.mask(i,j) == 1
                
                % find number of current chirp index
                chirp_idx = int32(find(data.range_offsets(2:end) - j > 0,1,'first'));
                if isempty(chirp_idx) % then j is within last chirp
                    chirp_idx = data.no_chirp_seq;
                end
                
                fread(fid,1,'int'); % number of bytes of the followng spectral block
                
                % spectra
                if data.CompEna == 0 

                    data.spec(i,j,1:data.DoppLen(chirp_idx)) = fread(fid,[1,data.DoppLen(chirp_idx)],'single'); % spectra
                    if data.DualPol > 0
                        data.spec_h(i,j,1:data.DoppLen(chirp_idx)) = fread(fid,[1,data.DoppLen(chirp_idx)],'single'); % spectra 
                        data.spec_covRe(i,j,1:data.DoppLen(chirp_idx)) = fread(fid,[1,data.DoppLen(chirp_idx)],'single'); % spectra 
                        data.spec_covIm(i,j,1:data.DoppLen(chirp_idx)) = fread(fid,[1,data.DoppLen(chirp_idx)],'single'); % spectra 
                    end
                    
                else
                    
                    Nblocks = int8(fread(fid,1,'char*1')); % number of blocks in spectra
                    MinBkIdx = fread(fid,[1, Nblocks],'int16') + 1; % minimum indexes of blocks
                    MaxBkIdx = fread(fid,[1, Nblocks],'int16') + 1; % maximum indexes of blocks
                    
                    for jj = 1:Nblocks
                        
                        data.spec(i,j,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                        
                        if data.DualPol > 0
                            
                            data.spec_h(i,j,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                            data.spec_covRe(i,j,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                            data.spec_covIm(i,j,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                            
                            if data.CompEna == 2
                                data.d_spec(i,j,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                                data.CorrCoeff(i,j,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                                data.DiffPh(i,j,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                                
                                if data.DualPol == 2
                                    data.SLDR(i,j,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                                    data.SCorrCoeff(i,j,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                                end 
                            end
                            
                            
                        end % if data.DualPol > 0                        
                           
                    end % jj
                    
                    if data.DualPol == 2 && data.CompEna == 2
                        data.KDP(i,j) = fread(fid,1,'single');
                        data.DiffAtt(i,j) = fread(fid,1,'single');
                    end
                    
                    data.VNoisePow_mean(i,j) = fread(fid,1,'single');
                    if data.DualPol > 0
                        data.HNoisePow_mean(i,j) = fread(fid,1,'single');
                    end
                    
                    if data.AntiAlias == 1
                        data.Aliasmask(i,j) = int8(fread(fid,1,'char*1'));
                        data.MinVel(i,j) = fread(fid,1,'single');
                    end
                                        
                end % data.CompEna == 0

            
            end % if data.mask(i,j)
        end % j
        
    end % i
    
    fclose(fid);                    
             
                  
    

end %function