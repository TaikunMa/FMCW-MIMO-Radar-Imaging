# Radar System design Using Matlab
Rapidly model and simulate phased array systems in the MATLAB and Simulink environments

Provides accurate longitudinal position and velocity measurements over long ranges, but has limited lateral accuracy at long ranges

Generates multiple detections from a single target at close ranges, but merges detections from multiple closely spaced targets into a single detection at long ranges

Sees vehicles and other targets with large radar cross-sections over long ranges, but has limited detection performance for nonmetallic objects such as pedestrians

Responsibilities in a project: 

Create a project to how to set up a radar system simulation consisting of a transmitter, a channel with a target and a receiver.

Skills: MATLAB, DSP System Toolbox


# Create a Tracker
Create a multiObjectTracker to track the vehicles that are close to the ego vehicle. The tracker uses the initSimDemoFilter supporting function to initialize a constant velocity linear Kalman filter that works with position and velocity.

Tracking is done in 2-D. Although the sensors return measurements in 3-D, the motion itself is confined to the horizontal plane, so there is no need to track the height.

tracker = multiObjectTracker('FilterInitializationFcn', @initSimDemoFilter, ...
    'AssignmentThreshold', 30, 'ConfirmationParameters', [4 5]);
positionSelector = [1 0 0 0; 0 0 1 0]; % Position selector
velocitySelector = [0 1 0 0; 0 0 0 1]; % Velocity selector

% Create the display and return a handle to the bird's-eye plot
BEP = createDemoDisplay(egoCar, sensors);

![dev1](https://user-images.githubusercontent.com/20502930/51167165-d73c6d00-18cb-11e9-91b1-d7026d5667f5.JPG)


# The Driving Scenario Designer app enables you to design synthetic driving scenarios for testing your autonomous driving systems.

## Using the app, you can:

Create road and actor models using a drag-and-drop interface.

Configure vision and radar sensors mounted on the ego car, and use these sensors to simulate detections of actors and lane boundaries in the scenario.

Load driving scenarios representing European New Car Assessment Programme (Euro NCAP®) test protocols [1][2][3] and other prebuilt scenarios.

Import OpenDRIVE® roads and lanes into a driving scenario. The app supports OpenDRIVE format specification version 1.4H [4].

Export sensor detections to MATLAB®, or generate MATLAB code of the scenario that produced the detections.

You can use synthetic detections generated from a scenario to test your sensor fusion or control algorithms. 

![dev2](https://user-images.githubusercontent.com/20502930/51167538-dc4dec00-18cc-11e9-9d04-88e4339dfed5.JPG)

