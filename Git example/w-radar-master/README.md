
This Matlab program reads data recorded with the FMCW-radar of RPG. RPG 
stores the data in binary format. The program converts it into netcdf4 
format. Additionally some reprocessing of the data can be applied including 
dealasing the radar spectra and the calculation of higher moments. 

The program was first created by Nils Küchler in 2018, and the first version of the 
program is available for the [JOYRAD-94 radar](https://github.com/nilskuechler/process_joyrad94_data) 
and the [MiRAC-A radar](https://github.com/nilskuechler/process_mirac-a_data). 
The code was restructured and updated in 2019 by Juan Antonio Bravo Aranda, 
Rosa Gierens and Lukas Pfitzenmaier to also include processing and dealiasing 
of compressed and polarized spectra.


## Content of this documentation: ##
0. General stucture
1. How to call the program
2. Setting data processing options (config file)
3. Input and output files

    3.1. Supported input files
    
    3.2. Output files: naming convention and types
    
4. Short description of the data processing

    4.1 Steps of the data processing

    4.2 Dealiasing
    
 X. References


####################### DESCRIPTION OF THE PROCESSING #####################


# 0. General stucture #

All code for this program is contained in direcotry scripts, and its 
subdirectories. It is assuemd that "scripts" is located in the same 
directory where you execute the program. The config file should also be in
the same directory, otherwise give full path of the config file instead of
config_radarname (see below).


# 1. How to call the program #

Call the scripts with:
- Raw2l1_radar('config_radarname')
    to process today's and yesterdays data
- Raw2l1_radar('config_radarname', 'yyyymmdd')
    to process the given date
- Raw2l1_radar('config_radarname', 'yyyymmd1', 'yyyymmd2') 
    to process all data from the first date to the second date



# 2. Setting data processing options (config file) #

The settings required for running the program have to be set in the 
configuration file (config_radarname, see above for calling the program). 
This file includes:
- input and output directories of the data
- sets radar options (radar location, radar name, contact person)
- processing options:
    - dealiasing
    - overwriting of output file(s)
    - debugging
    - definition of output file type
    - whether moments are calculated from spectra or copied from RPG lv1 
      file (this option is not available at the moment 10.7.2019)

See config_example.m for details.


# 3. Input and output files #

## 3.1 Supported input files ##

The program can handle 4 different file formats for lv0 files:
    i) binary files of type 1 created with RPG radar software version 1.
    ii) netcdf files created from i) where no additional processing 
        has been applied. 
    iii) binary files of type 2 created with RPG radar software version 2. 
    iv) binary files of type 3 created with RPG radar software version 3-5.
This program automatically identifies the file type and adjusts reprocessing
and creates a unified netcdf file for any of the file types i) to iv). 
Input data directory defined in config file (config.datapath). Data is 
assumed to be located in config.datapath/yyyy/mm/dd/
Note that you need to have read access to the directory.
The option of reading RPG lv1 binary files and converting them to netcdf is
not working at the moment (10.7.2019).

## 3.2 Output files: Naming convention and types ##

Two types of putput files are available. 
    i) general file: includes all metadata information, all flags, 
       all spectra, all moments
    ii) compact file: includes only moments (no spectra), some metadata 
Set in the config file if i), ii), or both should be created.

Naming convention for output files:
i) radarname_station_yyyymmddHHMMSS_program_scan.nc,
    example: joyrad94_nya_20190710000000_P01_ZEN.nc
ii) radarname_station_yyyymmddHHMMSS_program_scan_compact.nc,
    example: joyrad94_nya_20190710000000_P01_ZEN_compact.nc
where radarname and station are specified in config file, program refers to 
the program number (chirp table) defined in the RPG radar software, and 
scan is the scanning strategy also set in the RPW radar software. 'program' 
and 'scan' are copied from the input file name.

Output data directory defined in config file (config.outputpath). Data will
be written in config.outputpath/yyyy/mm/dd/*.nc If directories are not 
existing they will be created by the program. Note that you need to have 
write access to the target directory.


# 4. Short description of the data processing (Raw2l1_radar) #

Raw2l1_radar includes:
- Configures the time period to be processed
- Load config information
- Run code for each day selected: momentslv0
    - In momentslv0.m first search for input files for the day considered.
    - Per selected day, ech file is processed individually. Details below.

## 4.1. Steps of the data processing ##

This is the processing applied for each file in momentslv0.m.

### i) Check if output file already exist. 
If config.overwrite is set to 0, and the desired output files already 
exist, no processing of that file will be done. Program continues with 
next file.

### ii) Reading input data. 
First the lv0 file type is determined, and the corresponding reading 
function is assigned, for example read_lv0_v3.m (function whichReader.m).
If a new file type is introduced by RPG, a new reading function needs 
to be created. The input file is read into variable "data" (variable 
type structure).
    
### iii) Dataflags read from input data
- DualPol:   0 = radar has no polarimetric configuration, 
             1 = radar only measures LDR 
             2 = radar has full polarimetric measurement capabilities
- CompEna:   0 = not compressed
             1 = spectra compressed
             2 = spectra compressed and spectral polarimetric variable are stored in the file
             -> In the program these flag is called compress_spec. It has option 'true', combines option 1 and 2, or 
                'false'.
- AntiAlias: 0 = no dialiasing applied by RPG
             1 = dialiasing applied by RPG (July 2019 - this configuration still leads to significant bias in the data, 
                 Do not use this option!)

### iv) Additional variables added into "data" and missing values set to NaN.
    Function setting_data.m. If you want to add any variables into "data", 
    do it here.

### v) Radar specific settings to be applied before dealiasing. 
The function preprocessing_radarname.m is called if such a function
exist. Such a function is only necessary if you want to make any radar 
specific corrections or add missing meta data (relevant for early RPG 
software versions). Radar specific corrections are for example removing 
known artifacts from the spectra. Note that you can define corrections 
to only be applied for specific time periods. Each radar has its own 
function, and any adjustements are radar specific. The file name has to 
match the config.nickradar given in the config file. For a simple 
example of the preprocessing function see preprocessing_exampleradar.m.

### vi) Dealiasing and calculating moments 
If set in config file, and supported by the program, the dealising 
routine is called (function dealising.m). If dealising is not applied, 
moments are calculated from the non-dealiased spectra (function 
moments_retrieval.m). Details of the dealiasing in Section 4.2.

For non-compressed spectra, the spectra is treated before moment calculation as follows:
- Determining the mean and peak noise level using Hildebran-Sekon procedure
- Determining signficant signal as blocks with at least three consecutive 
bins above peak noise level. If a block is found it is extended by including 
all adjacent bins until the signal drops the first time below the mean noise level.
- The mean noise floor is subtracted from valid signal and spectral moments 
are calculated. 

For compressed spectra, only spectral bins are included where 5 
or more consecutive bins above noise are indentified.

Note that all moments are calculated for the entire spectra and not 
just for the main peak.


### vii) Radar specific settings to be applied after dealiasing. 
The function postprocessing_radarname.m is called if such a function
exist. Such a function is only necessary if you want to make any radar 
specific corrections, for example add known reflectivity offsets due
calibration issues. Note that you can define corrections to only be 
applied for specific time periods. Each radar has its own function, and 
any adjustements are radar specific. The file name has to match the 
config.nickradar given in the config file. For a simple example of the 
postprocessing function see postprocessing_exampleradar.m.

### viii) Write output data
Output file(s) are created and data is written to file(s). Function
savedata.m calls function write_joyrad94_data_2_nc.m for general file 
and function write_joyrad94_data_2_nc_compact.m for compact file. To 
add variables in output, edit the write***.m function(s).

## 4.2. Dealiasing routine description ##

The principle used for dealiasing the Doppler spectrum in the program is based 
on the method described in Maahn and Kollias, 2012, (Section 3.3.2) and Küchler 
et al., 2017, (Section 6b). The Doppler spectrum is aliaised, if the Nyquist 
velocity range (Min and Max velocity bin of the Doppler spectum) is set too narrow 
and the ambient conditions in the sampling volume (turbulence, particle fall 
velocities or up and down drafts) result in velocities outside of this range. 
If this effect is not corrected it leads to incorrect higher radar moments (mean 
Doppler velocity, Doppler spectrum width, Skewness). Here the steps of the 
dealiasing-program are briefly described. 

The principle used in this program is the following:
If terminal velocity of particles exceed the nyquist limit, then, in FMCW radar, 
their signal is folded into the upper and lower range gate. By concetenating 
adjacent spectra, the original spectrum can be recovered. The goodness of the 
dealiasing procedure is stored for each bin.

### i) Loop over time
Processing is done per spectrogram (one single time step including all Doppler 
spectra for all range gates). Further processing is only applied if any data 
found that are not 'NaN' in each spectrum per range. 
        
### ii) Check if aliaising occures (deailias_spectra_check_aliaising.m)
Flaggs range bins in which alaising occures. This is done by checking if the 
first and last 5% of the Doppler spectral bins contain data points above the 
noise floor (For 512 Doppler bins 5% of all Doppler bibs would be 26 bins). For 
compressed spectra any value given is by default above noise. For non-compressed 
spectra the noise floor is calculated by Hidebrand-Sekhon, 1974.
- Checking aliaising for polarimetric radar configuration. Check is not done for 
  the cross polar spectrum.
- If no dealising is found the moments are calculated from the spectra and the 
  program contineous with the next spectrogram.
          
### iii) Identify cloud layers
Dealiasing is applied for each cloud layer separately, so cloud layers 
have to be identified. If in a cloud layer aliasing occurs, the program
looks for the first non-dealiased Doppler spectra starting from cloud 
layer top and sets this as a reference bin.

### iv) Guess velocity
From the reference (see above), the first guess velocity is calculated. 
In case of issues, several alternative options for calculating the 
guess velocity are included.

### v) Concatenate spectra
The aliased spectra is concatenated with the spectra from 2 range gates 
below and above.

### vi) Find maximum 
The maximum in the concatenated spectra within +-Vnyq/2 from guess 
velocity is identied. The corresponding Doppler velocity bin is V_max.

### vii) Shift spectra
The spectrum is centered so that the contributions of the neighboring 
range gates are minimized. The center of the spectrum is shifted 
within  +-Vnyq/2 from V_max to the minimum of the first and last data
point. See figure 10 in Küchler et al, 2017. In addition, for compressed 
spectra if new mean Doppler velocity is close to the guess velocity,
and first and last 10% of the spectrum is empty, no shift is done.
- The cross-polar spectra is shifted exactly the same amount as the 
main polarisation component spectrum.

### viii) Quality check and calculating moments
For quality it is checked if majority of top 50% of the data points 
(above noise) are located in the center of the spectra. If so, moments 
are calculated. If not, it is once tried to adjusted the guess velocity.
It is shifted towards the mean velocity from neigbhouring bins in the 
previous time step, and dealiasing is attempted again.

### ix) Final quality check for entire file
After the entire file has been dealiased, last quality check for consistency
in time-height domain is done based on velocity differences. The difference
in mean Doppler velocity between two consecutive time bins is calculated
first, and then the mean of these differences for each vertical column. If 
these values exceed a threshold, the column is checked and the dealiasing 
is adjusted. For more details, see Section 4.3 in Küchler, 2019.


# X. References #

[Hildebrand and Sekhon, 1974 - Objective Determination of the Noise Level in Doppler Spectra; JAM](https://journals.ametsoc.org/doi/abs/10.1175/1520-0450(1974)013%3C0808:ODOTNL%3E2.0.CO%3B2)

[Küchler et al, 2017 - A W-Band Radar–Radiometer System for Accurate and Continuous Monitoring of Clouds and Precipitation; JTECH](https://journals.ametsoc.org/doi/full/10.1175/JTECH-D-17-0019.1)

[Küchler, 2019 - Ground-based remote sensing of warm low-level stratified clouds - new perspectives and applications; Dissertation, Universität zu Köln](https://kups.ub.uni-koeln.de/9437/)

[Maahn and Kollias, 2012 - Improved Micro Rain Radar snow measurements using Doppler spectra post-processing; AMT](https://www.atmos-meas-tech.net/5/2661/2012/)


