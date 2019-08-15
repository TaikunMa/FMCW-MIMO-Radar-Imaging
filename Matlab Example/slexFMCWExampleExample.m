%% Automotive Adaptive Cruise Control Using FMCW and MFSK Technology
% This example shows how model of an automotive radar in Simulink for an
% adaptive cruise control (ACC) system, which is an important part of an
% advanced driver assistance system (ADAS). The example explores both
% single and multiple targets scenarios. It shows how FMCW and MFSK
% waveforms can be processed to estimate the range and speed of surrounding
% vehicles.
%
% *Available Example Implementations*
%
% This example includes four Simulink(R) models:
%
% * FMCW Radar Range Estimation: <matlab:slexFMCWExample
% slexFMCWExample.slx>
% * FMCW Radar Multiple Targets Range and Speed Estimation: 
% <matlab:slexFMCWMultiTargetsExample slexFMCWMultiTargetsExample.slx>
% * Multiple Targets Range and Speed Estimation Using MFSK: 
% <matlab:slexMFSKMultiTargetsExample slexMFSKMultiTargetsExample.slx>
% * FMCW Radar Multiple Targets Range, Speed, and Angle Estimation:
% <matlab:slexFMCWMultiTargetsDOAExample
% slexFMCWMultiTargetsDOAExample.slx>

%   Copyright 2014-2017 The MathWorks, Inc.

%% FMCW Radar Range Estimation
% The following model shows an end-to-end FMCW radar system. The system
% setup is similar to the MATLAB <docid:phased_examples.example-ex11665805>
% example. The only difference is in this model the FMCW waveform sweep is
% symmetric around the carrier frequency.

helperslexFMCWSim('runModel');
helperslexFMCWSim('openModel');

%%
% The figure shows the signal flow in the model. The Simulink blocks which
% make up the model are divided into two major sections, the *Radar*
% section and the *Channel and Target* section. The shaded block on the
% left represents the radar system. In this section, the FMCW signal is
% generated and transmitted. This section also contains the receiver which
% captures the radar echo and performs a series of operations, such as
% dechirp and pulse integration, to estimate the target range. The shade
% block on the right models the propagation of the signal through space and
% its reflection from the car. The output of the system, the estimated
% range in meters is shown in the display block on the left.
%
% *Radar* 
%
% The radar system consists of a co-located transmitter and a receiver
% mounted on a vehicle moving along a straight road. It contains the signal
% processing components needed to extract the information from the returned
% target echo.
%
% * |FMCW| - Create FMCW signal. The FMCW waveform is a common choice in
% automotive radar because it provides a way to estimate the range using a
% continuous wave radar. The distance is proportional to the frequency
% offset between the transmitted signal and received echo. The signal
% sweeps a bandwidth of 150 MHz, which translates to a 1-meter resolution.
% * |Transmitter| - Transmits the waveform. The operating frequency of the
% transmitter is 77 GHz.
% * |Receiver Preamp| - Receives the target echo and adds the receiver
% noise.
% * |Radar Platform| - Simulates radar vehicle trajectory.
% * |Signal Processing| - Processes the received signal and derives the
% range of the target vehicle.
%
% Within the *Radar*, the target echo goes through several signal
% processing steps in order to derive the target range. The signal
% processing subsystem, shown in more detail below, consists of three
% blocks. The first block dechirps the received signal by multiplying it
% with the transmitted signal. This operation produces a beat frequency
% between the target echo and the transmitted signal. The target range is
% proportional to the beat frequency. This operation also reduces the
% bandwidth required to process the signal. The second block sends the
% dechirped pulses through a pulse integrator to boost the signal-to-noise
% ratio (SNR). The third block, the Range Estimator, generates a
% periodogram, from which the peak is located to obtain the beat frequency.
% Estimating range becomes essentially a spectral analysis problem.

helperslexFMCWSim('showSignalProcessing');

%%
% *Channel and Target*
%
% The *Channel and Target* part of the model simulates the signal
% propagation and reflection off the target vehicle.
%
% * |Channel| - Simulates the signal propagation between the 
% radar vehicle and the target vehicle. The channel can be set as either a
% line of sight free space channel, or a two-ray channel where the signal
% arrives at the receiver via both the direct path and the reflected path
% off the ground. The default choice is a free space channel.

helperslexFMCWSim('showChannel');

%%
% * |Car| - Reflects the incident signal and simulates the target vehicle
% trajectory. The subsystem, shown below, consist of two parts: a target
% model to simulate the echo and a platform model to simulate the dynamics
% of the target vehicle.

helperslexFMCWSim('showCar');

%%
% In the Car subsystem, the target vehicle is modeled as a point target
% with a specified radar cross section. The radar cross section is used to
% measure how much power can be reflected from a target.
%
% In this model's scenario, the radar vehicle starts at the origin,
% traveling at 100 km/h (27.78 m/s), while the target vehicle starts at 50
% meters in front of the radar vehicle, traveling at 96 km/h (26.67 m/s).
% The positions and velocities of both the radar and the target vehicles
% are used in the propagation channel to calculate the delay, Doppler, and
% signal loss.

%% 
% *Exploring the Model*
%
% Several dialog parameters of the model are calculated by the helper
% function <matlab:edit('helperslexFMCWParam') helperslexFMCWParam>. To
% open the function from the model, click on |Modify Simulation Parameters|
% block. This function is executed once when the model is loaded. It
% exports to the workspace a structure whose fields are referenced by the
% dialogs. To modify any parameters, either change the values in the
% structure at the command prompt or edit the helper function and rerun it
% to update the parameter structure.

%% 
% *Results and Displays*
%
% The spectrogram of the FMCW signal below shows that the signal linearly
% sweeps a span of 150 MHz approximately every 7 microseconds. This
% waveform provides a resolution of approximately 1 meter.

helperslexFMCWSim('showFMCWSpectrogram');

%%
% The spectrum of the dechirped signal is shown below. The figure indicates
% that the beat frequency introduced by the target is approximately 100
% kHz. Note that after dechirp, the signal has only a single frequency
% component. The resulting range estimate calculated from this beat
% frequency, as displayed in the model, is 49.95 meters, which is within
% the range resolution.

helperslexFMCWSim('showDechirpSpectrogram');

%%
% However, this result is obtained with the free space propagation channel.
% In reality, the propagation between vehicles often involves multiple
% paths between the transmitter and the receiver. Therefore, signals from
% different paths may add either constructively or destructively at the
% receiver. The following section set the propagation to a two-ray channel,
% which is the simplest multipath channel.

helperslexFMCWSim('closePlots');
helperslexFMCWSim('useTwoRay');
helperslexFMCWSim('showChannel');

%% 
% Run the simulation and observe the spectrum of the dechirped signal.

helperslexFMCWSim('runModel');
helperslexFMCWSim('showDechirpSpectrogram');


%%
% Note that there is no longer a dominant beat frequency because at this
% range, the signal from the direct path and the reflected path cancels
% each other out. This can also be seen from the estimated range. which no
% longer matches the ground truth.

helperslexFMCWSim('closeModel')

%% Multiple Targets Ranges and Speeds Estimation Using FMCW Waveform
% The example model below shows a similar end-to-end FMCW radar system
% working with two targets. This example also estimates the speed
% of both target vehicles.

helperslexFMCWMultiTargetsSim('runModel');
helperslexFMCWMultiTargetsSim('openModel');

%%
% The model is essentially the same as the previous example with two
% differences. Besides having two targets, the radar system now uses
% range-Doppler joint processing.
%
% *Radar*
%
% This model uses range Doppler joint processing in the signal processing
% subsystem. Joint processing in range-Doppler domain makes it possible to
% estimate the Doppler across multiple sweeps and then to use that
% information to resolve the range-Doppler coupling, resulting in better
% range estimates.
%
% The signal processing subsystem is shown in detail below.

helperslexFMCWMultiTargetsSim('showSignalProcessing')

%%
% The blocks that make up the signal processing subsystem are
%
% * |Dechirp| - Dechirps the received signal.
% * |Pulse Buffer| - Buffers the incoming signal to form a fast time vs. 
% slow time matrix.
% * |Range Doppler Response| - Computes the range-Doppler map based on the
% signal matrix.
% * |Up Sweep Range Speed Estimation| - Estimates the range and speed of
% the targets from the range-Doppler map.
% 
% Once the signal is dechirped, it is buffered to form a matrix and then
% processed to generate the corresponding range-Doppler map. The next step
% analyzes the map and derives the range and speed of the targets. The
% details of the range and speed estimation are shown below.

helperslexFMCWMultiTargetsSim('showRangeDopplerJointEstimation')

%%
% * |Range Estimator| - Estimates the target range from the range-Doppler
% map.
% * |Speed Estimator| - Estimates the target speed from the range-Doppler
% map based on the range estimates.
% * |Range Doppler Decoupler| - Removes the range estimation error due to
% range-Doppler coupling.
%
% As mentioned in the beginning of the example, FMCW radar uses a frequency
% shift to derive the range of the target. However, the motion of the
% target can also introduce a frequency shift due to the Doppler effect.
% Therefore, the beat frequency has both range and speed information
% coupled. Processing range and Doppler at the same time lets us remove
% this ambiguity. As long as the sweep is fast enough so that the target
% remains in the same range gate for several sweeps, the Doppler can be
% calculated across multiple sweeps and then be used to correct the initial
% range estimates.
%
% *Channel and Target*
%
% There are now two target vehicles in the scene, labeled as Car and Truck,
% and each vehicle has an associated propagation channel. The Car starts 50
% meters in front of the radar vehicle and travels at a speed of 60 km/h
% (16.67 m/s). the Truck starts at 150 meters in front of the radar vehicle
% and travels at a speed of 130 km/h (36.11 m/s). 

%% 
% *Exploring the Model*
%
% Several dialog parameters of the model are calculated by the helper
% function <matlab:edit('helperslexFMCWMultiTargetsParam')
% helperslexFMCWMultiTargetsParam>. To open the function from the model,
% click on |Modify Simulation Parameters| block. This function is executed
% once when the model is loaded. It exports to the workspace a structure
% whose fields are referenced by the dialogs. To modify any parameters,
% either change the values in the structure at the command prompt or edit
% the helper function and rerun it to update the parameter structure.

%% 
% *Results and Displays*
%
% The FMCW signal shown below is the same as in the previous model.

helperslexFMCWMultiTargetsSim('showFMCWSpectrogram');

%%
% The two targets can be visualized in the range-Doppler map below.

helperslexFMCWMultiTargetsSim('showRangeDopplerMap');

%%
% The map correctly shows two targets: one at 50 meters and one at 150
% meters. Because the radar can only measure the relative speed, the
% correct estimates of speeds for these two vehicles are 11.11 m/s and -8.3
% m/s, respectively, where the negative sign indicates that the Truck is
% moving away from the radar vehicle. The exact speed estimates may be
% difficult to read out from the map, but the estimated ranges and speeds
% are shown in the display blocks in the block diagram. From the displayed
% results, the speed estimates are also correct.

%% Multiple Targets Ranges and Speeds Estimation Using MFSK Waveform
% To be able to do joint range and speed estimation using the above
% approach, the sweep needs to be fairly fast to ensure the vehicle is
% approximately stationary during the sweep. This often translates to
% higher hardware cost. MFSK is a new waveform designed specifically for
% automotive radar so that it can achieve simultaneous range and speed
% estimation with longer sweeps.
%
% The example below shows how to use MFSK waveform to perform the range and
% speed estimation. The scene setup is the same as the previous model.

helperslexMFSKMultiTargetsSim('runModel');
helperslexMFSKMultiTargetsSim('openModel');

%% 
% The only differences are in the waveform block and the signal processing
% subsystem. The details of MFSK waveform is described in the
% <docid:phased_examples.example-ex70175985> example but it essentially
% consists of two FMCW sweeps with a fixed frequency offset. The sweep also
% happens at discrete steps. From the parameters of the MFSK waveform
% block, the sweep time can be computed as the product of the step time and
% the number of steps per sweep. In this example, the sweep time is
% slightly over 2 ms, which is several orders larger than the 7
% microseconds for the FMCW used in the previous model.

helperslexMFSKMultiTargetsSim('showWaveform');

%%
% The signal processing subsystem describes how the signal gets processed
% for the MFSK waveform. The signal is first sampled at the end of each
% step and then converted to frequency domain via FFT. A CFAR detector is
% used to identify the peaks, which correspond to targets, in the spectrum.
% Then the frequency at each peak location as well as the phase difference
% between the two sweeps are used to estimate the range and speed of target
% vehicles.

helperslexMFSKMultiTargetsSim('showSignalProcessing');

%% 
% *Exploring the Model*
%
% Several dialog parameters of the model are calculated by the helper
% function <matlab:edit('helperslexMFSKMultiTargetsParam')
% helperslexMFSKMultiTargetsParam>. To open the function from the model,
% click on |Modify Simulation Parameters| block. This function is executed
% once when the model is loaded. It exports to the workspace a structure
% whose fields are referenced by the dialogs. To modify any parameters,
% either change the values in the structure at the command prompt or edit
% the helper function and rerun it to update the parameter structure.

%% 
% *Results and Displays*
%
% The estimated result is shown in the model, matching the result obtained
% from the previous model.

%%
helperslexFMCWMultiTargetsSim('closeModel');
helperslexMFSKMultiTargetsSim('closeModel');

%% Multiple Targets Ranges, Speeds, and Angles Estimation 
% One can improve the angular resolution of the radar by using an array of
% antennas. This example shows how to resolve three target vehicles
% traveling in separate lanes ahead of a vehicle carrying an antenna array.

helperslexFMCWMultiTargetsDOASim('runModel');
helperslexFMCWMultiTargetsDOASim('openModel');

%%
% In this scenario, the radar is traveling in the center lane of a highway
% at 65 mph. The first target vehicle is traveling 20 meters ahead in the
% same lane as the radar at 55 mph. The second target vehicle is traveling
% at 80 mph in the right lane and is 40 meters ahead. The third target
% vehicle is traveling at 70 mph in the left lane and is 80 meters ahead.
% The antenna array of the radar vehicle is a 4-element ULA.

%%
% Fix the origin of the coordinate system at the radar vehicle, the ground
% truth range, speed, and angle of the target vehicles with respect to the
% radar is
%
%                  Range (m)      Speed (m/s)        Angle (deg)
%    ---------------------------------------------------------------
%      Car 1         20               4.44              0
%      Car 2         40.05           -6.66             -2.86
%      Car 3         80.03           -2.22              1.43
%
% The signal processing subsystem now includes direction of arrival
% estimation in addition to the range and Doppler processing units.

helperslexFMCWMultiTargetsDOASim('showSignalProcessing');

%%
% As shown in the diagram, the first step in the signal processing chain is
% range estimation. Once the range a target is estimated, the data in the
% corresponding range bins are used to estimate the speed (range
% rate) and the direction of arrival of the same target. 

%% 
% *Exploring the Model*
%
% Several dialog parameters of the model are calculated by the helper
% function <matlab:edit('helperslexFMCWMultiTargetsDOAParam')
% helperslexFMCWMultiTargetsDOAParam>. To open the function from the model,
% click on |Modify Simulation Parameters| block. This function is executed
% once when the model is loaded. It exports to the workspace a structure
% whose fields are referenced by the dialogs. To modify any parameters,
% either change the values in the structure at the command prompt or edit
% the helper function and rerun it to update the parameter structure.

%% 
% *Results and Displays*
%
% The estimated result is shown in the model. The range estimates are
% within 0.5 meter; the speed estimates are within 0.1 m/s; and the angle
% estimates are within 0.1 degrees. Therefore, the estimates matching the
% ground truth well.

helperslexFMCWMultiTargetsDOASim('closeModel');

%% Summary
% The first model shows how to use an FMCW radar to estimate the range of
% a target vehicle. The information derived from the echo, such as the
% distance to the target vehicle, are necessary inputs to a complete
% automotive ACC system.
%
% The example also discusses how to perform range Doppler processing to
% derive both range and speed information of target vehicles. However, it
% is worth noting that when the sweep time is long, the system capability
% for estimating the speed is degraded and it is possible that the joint
% processing can no longer provide accurate compensation for range Doppler
% coupling. More discussion on this topic can be found in the MATLAB
% <docid:phased_examples.example-ex11665805> example.
% 
% Next model shows how to perform the same range and speed estimation
% using MFSK waveform instead. This waveform can achieve the joint range
% and speed estimation with longer sweeps, thus reducing the hardware
% requirements.
% 
% The last model shows uses FMCW waveform again and shows how to perform
% the range, speed, and angle estimation simultaneously if an antenna array
% is available in the radar system.
