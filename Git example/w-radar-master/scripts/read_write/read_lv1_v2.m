function data = read_lv1_v2(infile)

% reads binary files from lv1 of joyrad94 and return data in a struct
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
    data.DualPol = int8(fread(fid,1,'char*1')); % 0 = single pol radar, 1 = dual pol radar LDR conf., 2 = dual pol radar STSR mode
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
    data.DoppLen = int32(fread(fid,[1, data.no_chirp_seq],'int')); % number of samples in doppler spectra of each chirp sequence
    data.range_offsets = int32(fread(fid,[1, data.no_chirp_seq],'int')) + 1; % chirp sequences start index array in altitude layer array
    data.SeqAvg = int32(fread(fid,[1, data.no_chirp_seq],'int')); % number of averaged chirps within a sequence
    data.SeqIntTime = single(fread(fid,[1, data.no_chirp_seq],'single')); % effective sequence integration time [sec]
    data.dr = single(fread(fid,[1, data.no_chirp_seq],'single')); % chirp sequence range resolution [m]
    data.DoppMax = single(fread(fid,[1, data.no_chirp_seq],'single')); % maximum unambiguious Doppler vel for each chirp sequence
    data.totsamp = int32(fread(fid,1,'int'));  % total number of samples
    
    data.CompEna = 0;  % spectral compression flag
    data.Fr = NaN; % range factors
    
    
    % ################################# header ends
    
    data.nAvg = data.SeqAvg./data.DoppLen; % number of spectral averages
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% allocate arrays
    
    data.samplen(1:data.totsamp) = int32(0); % sample length in bytes without samplen
    data.time(1:data.totsamp) = int32(0); % time of sample [sec] since 1.1.2001 0:0:0
    data.sampleTms(1:data.totsamp) = single(-999); % milliseconds of sample
    data.QF(1:data.totsamp,1:4) = '0'; % quality flag: bit 2 = ADC saturation, bit 3 = spectral width too high, bit 4 = no transm. power leveling
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
    % data.reserved(1:3,1:data.totsamp) = single(-999);
    % data.Tprof(1:data.T_altcount,1:data.totsamp) = single(-999); % temperature profile
    % data.Qprof(1:data.H_altcount,1:data.totsamp) = single(-999); % abs hum profile
    % data.RHprof(1:data.H_altcount,1:data.totsamp) = single(-999); % rel hum profile
    data.SLv(1:data.totsamp,1:data.n_levels) = single(-999); % linear sensitivity limit in Ze units for vertical polarisation
    data.mask(1:data.totsamp,1:data.n_levels) = int8(0); % data.mask array of occupied range cells: 0=not occupied, 1=occupied
    data.Ze(1:data.totsamp,1:data.n_levels) = single(-999); % linear reflectivity vert. pol.
    data.vm(1:data.totsamp,1:data.n_levels) = single(-999); % mean Doppler vert. pol. [m/s]
    data.sigma(1:data.totsamp,1:data.n_levels) = single(-999); % spectral width vert. pol. [m/s]
    data.skew(1:data.totsamp,1:data.n_levels) = single(-999); % skewness vert. pol.
    data.kurt(1:data.totsamp,1:data.n_levels) = single(-999); % kurosis vert. pol.
    
    if data.DualPol > 0
        data.SLh(1:data.totsamp,1:data.n_levels) = single(-999); % linear sensitivity limit in Ze units for horizontal polarisation
        data.dZ(1:data.totsamp,1:data.n_levels) = single(-999); % differential reflectivity [dB]
        data.CorrCoeff(1:data.totsamp,1:data.n_levels) = single(-999); % rho_hv, spectral corellation coefficient [0,1]
        data.DiffPh(1:data.totsamp,1:data.n_levels) = single(-999); % differential phase [rad]
        
            if data.DualPol == 2 
                data.Ze45(1:data.totsamp,1:data.n_levels) = single(-999);
                data.SLDR(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % compressed spectral slanted LDR [dB]
                data.SCorrCoeff(1:data.totsamp,1:data.n_levels,1:max(data.DoppLen)) = single(-999); % compressed spectral slanted correlation coefficient [0,1]
                data.KDP(1:data.totsamp,1:data.n_levels) = single(-999); % specific differential phase shift [rad/km]
                data.DiffAtt(1:data.totsamp,1:data.n_levels) = single(-999); % differential attenuation [dB/km]                  
            end % data.DualPol
        
    end   

    

     
    %############################## end allocating
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% start reading the rest of the file
    for i = 1:data.totsamp
        
        data.samplen(i) = fread(fid,1,'int');
        data.time(i) = fread(fid,1,'uint');
        data.sampleTms(i) = fread(fid,1,'int');
        data.QF(i,1:4) = fread(fid,1,'char*1');
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
        data.reserved(i,1:3) = fread(fid,3,'single'); % reserved
        fread(fid,data.T_altcount,'single'); % temp prof
        fread(fid,data.H_altcount,'single'); % abs hum prof
        fread(fid,data.H_altcount,'single'); % rel hum prof
            
        data.SLv(i,1:data.n_levels) = fread(fid,[1, data.n_levels],'single');
        if data.DualPol > 0
            data.SLh(i,1:data.n_levels) = fread(fid,[1, data.n_levels],'single');
        end
        
        data.mask(i,1:data.n_levels) = int8(fread(fid,[1, data.n_levels],'char*1'));        
        
        for j = 1:data.n_levels
                        
            if data.mask(i,j) == 1
                
                data.Ze(i,j) = fread(fid,1,'single');
                data.vm(i,j) = fread(fid,1,'single');
                data.sigma(i,j) = fread(fid,1,'single');
                data.skew(i,j) = fread(fid,1,'single');
                data.kurt(i,j) = fread(fid,1,'single');
                
                if data.DualPol > 0
                    
                    data.dZ(i,j) = fread(fid,1,'single');
                    data.CorrCoeff(i,j) = fread(fid,1,'single');
                    data.DiffPh(i,j) = fread(fid,1,'single');
                    
                    if data.DualPol == 2
                        
                        data.Ze45(i,j) = fread(fid,1,'single');
                        data.SLDR(i,j) = fread(fid,1,'single');
                        data.SCorrCoeff(i,j) = fread(fid,1,'single');
                        data.KDP(i,j) = fread(fid,1,'single');
                        data.DiffAtt(i,j) = fread(fid,1,'single');
                        
                    end
                    
                end % DualPol > 0
            
            end % if data.mask(i,j)
            
        end % j
        
    end % i
    
    fclose(fid);                 
             
                  
    

end %function