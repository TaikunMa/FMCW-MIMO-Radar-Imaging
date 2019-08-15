function data = read_netcdf_v1(infile)

% Author: Nils Küchler
% created: 9 February 2017
% modified: 9 Feburary 2017, Nils Küchler 

% reads netcdf files that contain joyrad94 data produced with the first
% software version
% adds variables manually that are available with the newsoftware version.
% this is for homogenizing further processing

    varlist = get_varlist; % variable names that are importet. see function below.
    data = netcdf2struct(infile,varlist);

    %%%%%%%%%%%%%%%%%%%%%%% rename variables to be consistent with other
    %%%%%%%%%%%%%%%%%%%%%%% reading routines
    data.T_env = data.Tenv;
    data = rmfield(data,'Tenv');
    data.no_chirp_seq = data.chirp_seq;    
    data = rmfield(data,'chirp_seq');
    data.CalInt = data.CallInt;
    data = rmfield(data,'CallInt');
    data.powIF = data.PowIF;
    data = rmfield(data,'PowIF');
    data.sampleTms = data.int_time; % variable was named wrongly in old processing script
    data = rmfield(data,'int_time');
    data.u = data.vol;
    data = rmfield(data,'vol');

    %%%%%%%%%%%%%%%%%%%%% permute data    
    names = fieldnames(data);
    
    for i = 1:numel(names)
        
        if numel(data.(names{i})) > 1
            s = size(data.(names{i}));
            data.(names{i}) = permute(data.(names{i}),numel(s):-1:1);
        end
        
    end % i
    

    %%%%%%%%%%%%%%%%%%%%%%% add manually variables included in later software version
    
    % norther latitude and eastern longitute have positive signs
    
    if ~isempty(strfind(infile,'nya')) % then data was collected in Ny Alesund
        data.Lat = 78.9233;
        data.Lon = 11.9224;
        data.MSL = 111. + 19.5 + 1; % height above sea level + height of platform above ground + height of dish above platform   
    else % it was collected in Jülich
        data.Lat = 50.9086;
        data.Lon = 6.4135;
        data.MSL = 11.; % height above sea level
    end % if
    
    data.totsamp = numel(data.time);
    data.freq = 93.9997; % [GHz]
    data.AntDia = 0.5000; % [m]
    data.AntG = 1.4454e+05;
    data.Lat = NaN; % latitude
    data.Lon = NaN; % longitude
    data.DualPol = 0; % 0 = single pol radar, 1 = dual pol radar LDR conf., 2 = dual pol radar STSR mode
    data.CompEna = 0;  % spectral compression flag: 0 = not compressed, 1 = spectra compressed, 2 = spectra compressed and spectral polarimetric variables stored in the file
    data.AntiAlias = 0; % 0 = Doppler spectra are not anti-aliased, 1 = doppler spectra have been anti-aliased
    data.T_altcount = 0; % number of temperature profile altitude layers
    data.H_altcount = 0; % number of humidity profile altitude layers
    data.T_alt = NaN; % temp prof altitude layers
    data.H_alt = NaN; % hum prof altitude layers
    data.Fr = NaN(1,data.n_levels); % range factors
    data.modelno = 0;
    
    if numel(data.range) == 1021 % then high res mode was on
        data.SeqAvg = int32([4096, 3072, 2304, 1792]); % number of averaged chirps within a sequence
        data.SeqIntTime = [0.530, 0.590, 0.731, 0.568]; % effective sequence integration time [sec]
        data.nAvg = data.SeqAvg./data.DoppLen; % number of spectral averages
        data.progname = 'High Res';
    elseif numel(data.range) == 388
        data.SeqAvg = int32([4096, 4096, 4096, 9216]); % number of averaged chirps within a sequence
        data.SeqIntTime = [0.338, 0.402, 0.530, 1.769]; % effective sequence integration time [sec]
        data.nAvg = data.SeqAvg./data.DoppLen; % number of spectral averages
        data.progname = 'Doppler 3 sec';
    else
        data.nAvg = int32(ones(1,data.no_chirp_seq)*5); % number of spectral averages
        data.SeqAvg = data.nAvg.*data.DoppLen; % number of averaged chirps within a sequence
        data.SeqIntTime = zeros(1,data.no_chirp_seq); % effective sequence integration time [sec]
        data.progname = 'Unknown';
    end
    
    data.QF = NaN(1,data.totsamp);  % quality flag: bit 2 = ADC saturation, bit 3 = spectral width too high, bit 4 = no transm. power leveling    
    data.PNv = NaN(data.totsamp,data.n_levels); % total IF power in v-pol measured at the ADC input
    data.SLv = NaN(data.totsamp,data.n_levels); % linear sensitivity limit in Ze units for vertical polarisation
    
    % set radar constant to a single value
    data.C = data.C(1);    
    

end % function read_netcdf_v1

function varlist = get_varlist()

% contains names of variables that are contained in the netcdf files
% created with radar software version 1

varlist = {...
    'filecode',...
    'n_levels',...
    'range',...
    'chirp_seq',...
    'range_offsets',...
    'dr',...
    'DoppLen',...
    'DoppRes',...
    'DoppMax',...
    'CallInt',...
    'AntSep',...
    'HPBW',...
    'SampDur',...
    'velocity',...
    'chirp_sequences',...
    'time',...
    'int_time',...
    'RR',...
    'rh',...
    'Tenv',...
    'pres',...
    'ff',...
    'fff',...
    'vol',...
    'Tb',...
    'lwp',...
    'PowIF',...
    'ele',...
    'az',...
    'status',...
    'TransPow',...
    'T_trans',...
    'T_rec',...
    'T_pc',...
    'C',...
    'std_noise',...
    'mask',...
    'Ze',...
    'vm',...
    'sigma',...
    'skew',...
    'kurt',...
    'spec'
    };

end % function varlist
