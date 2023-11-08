# SACCURATE: Saccade Curation GUI for Ground Truth Dataset Construction, Post Curation and Evaluation

SACCURATE has been developed in  [Shadmehr Lab](http://www.shadmehrlab.org), [Department of Biomedical Engineering](https://www.bme.jhu.edu), [Johns Hopkins University](https://www.jhu.edu)

![Theme Figure](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/theme_figure.jpg)
![Overview Figure](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/overview_figure.svg)
------------------

## <a name="content">Content</a> 

- [Introduction](#introduction)
- [SACCURATE Main Window](#SACCURATE-main-window)
- [Time Trace Module](#time-trace-module)
- [Saccade Feature Module](#saccade-feature-module)
- [Trajectory Module](#trajectory-module)
- [Prerequisite Environment](#prerequisite-environment)
- [Data Structure](#data-structure)
- [Installation](#installation)

## <a name="introduction">Introduction</a> 

Accurate saccade detection is crucial in neuroscience tasks related to reward, motor function, and learning. Deep learning networks have proven to be superior in detecting saccades compared to traditional thresholding methods, regardless of the saccade amplitude. However, in order to utilize these saccade detection tools, it is essential to have a reliable dataset for training the network. There are situations where automatic saccade detection algorithms may not yield satisfactory results, requiring manual post-curation. Additionally, when experimenting with new detection tools, it is beneficial to directly compare the detection results with other tools or ground truth data and thoroughly examine any incorrect detections for systematic error analysis. To address these needs, we introduce SACCURATE as a comprehensive tool that facilitates ground truth dataset construction, post-curation, and evaluation.

[back to start](#content)

## <a name="SACCURATE-main-window">SACCURATE Main Window</a> 

![Main Window](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/main_window.png)

The main window of SACCURATE is displayed above, including [time trace module](#time-trace-module) on the left, [saccade feature module](#saccade-feature-module) on the upper right and [trajectory module](#trajectory-module) on the lower right. For more detailed descriptions of each module, please refer to the sections below.

![Toolbar](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/toolbar.png)


At the top of the interface, you'll find a convenient toolbar with quick functions for easy access. These functions include options to open a file, save a file, redo the previous action (with up to 5 steps in the history), discard all changes, navigate to the start of the recording, and navigate to the end of the recording. The toolbar is organized from left to right. Additionally, there is a panel that displays the name of the file you are currently editing, allowing you to keep track of your progress.

![Helpme Figure](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/helpme_figure.png)

At the bottom of the interface, there is an instructional figure that serves as a quick reminder of how to use the GUI. Additionally, you can click on the "Help" option in the top panel for more detailed descriptions and guidance. Below, you will find a list of instructions for reference:

### <a name="instruction-table">Instruction Table</a> 
| Event | Effect Description |
| ------ | ------------------ |
| F or Rightarrow | move time window to the right by move length |
| S or Leftarrow | move time window to the left by move length |
| E or Uparrow | increase move length |
| D or Downarrow | decrease move length |
| A | select and move to previous saccade on Saccade trace |
| G | select and move to next saccade on Saccade trace |
| Q | select and move to previous saccade on Saccade(ref) trace |
| T | select and move to next saccade on Saccade(ref) trace |
| R | select current saccade the mouse is pointing at |
| Space | modify all selected regions to fixation period (0) |
| H | show or hide target trace in time window |
| Delete | batch delete all saccades in ROI |
| Backspace | undo one step, with up limit of 5 steps |
| Left Click and Drag on Time Window | manually label saccade period (1) |
| Right Click and Drag on Time Window | manually label fixation period (0) |
| Left Double Click on Time Window | automatically label saccade period (1) |
| Right Double Click on Time Window | automatically label fixation period (0) |
| Scroll on Time Window | change window time duration displayed |
| Scroll on Trace Plot | zoom in or zoom out trace plot |
| Left Click on Feature Plot | selected ROI which could be selected, finished with left double click or quit with right click|
| Right Click Drag on Feature Plot | move feature plot |
| Scroll on Feature Plot | zoom in or zoom out sequence plot |

You can find more details about these usage from modules descriptions below.

[back to start](#content)

## <a name="time-trace-module">Time Trace Module</a> 

![Time Trace Plot](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/time_trace_plot.png)

This module is located on the left side of the main window and displays a detailed signal trace over time, allowing for modifications. There are five traces in total: X position trace (in degrees), Y position trace (in degrees), unfiltered absolute velocity (in degrees per millisecond), saccade reference trace, and saccade trace, listed from top to bottom.

On the X and Y position traces, the blue line represents the eye movement signal trace, while the yellow dotted line (optional) represents the target trace for the eye to follow. The saccade reference trace and saccade trace indicate saccade periods, where a value of 1 on the blue trace indicates a saccade eye movement period, and a value of 0 indicates a non-saccade period (such as fixation, drift, or blink). Optionally, there is a gray trace that shows the probability of saccades given by the deep net algorithm. The saccade reference trace is used as a detection reference for comparison. For example, it can be used to evaluate the performance of an algorithm by showing the detection ground truth, or to compare the results of a previous algorithm when testing a new one. It can also serve as an additional guide during post-curation by combining results from two algorithms. The module also includes green lines indicating reference saccade onset and numbers showing relative information about saccade tags.

The saccade reference trace is optional and only serves as a reference; you cannot modify the saccades on that trace. However, the saccade trace is where you can perform curation. You can left-click and drag to label saccade periods, or right-click and drag to label non-saccade periods. Additionally, you can double-click near a saccade, and a traditional thresholding method will automatically detect the saccade for you around that period. If no saccade is detected by double-clicking, it may be too small to be detected by the traditional thresholding method, so you will need to label it manually.

You can also align the saccade onset and offset to the X, Y, and velocity traces by "selecting" the saccade and coloring it green. To view saccades outside of the current time window, you can either move the time window forward and backward or directly select and go to the next or previous saccade on the saccade trace or saccade reference trace. Shortcut commands are provided to adjust the time window size, adjust the length of the time window movement, show/hide the target trace, erase the currently selected saccade, or undo the previous step. Please refer to the [Instruction Table](#instruction-table) for further details.

![Statistics](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/statistics.png)

At the bottom of the interface, you can find the current statistics of various parameters:

 - Data sample frequency: This indicates the frequency at which data samples are recorded.
 
 - Time window move length: It represents the length of the time window movement when navigating through the data.

 - Time window display duration: This indicates the duration for which the time window is displayed on the screen.
 
 - Saccade selected trace: It shows on which trace (saccade reference or saccade trace) saccade is currently selected.
 
These parameters provide you with important information about the data and the current settings, enabling you to track and adjust them as needed.

[back to start](#content)

## <a name="saccade-feature-module">Saccade Feature Module</a> 

![Feature Plot](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/feature_plot.png)


This module is displayed on the upper right of the main window and presents the feature space of all saccades on the saccade trace or saccade reference trace. The available features include:

### <a name="feature-table">Feature Table</a> 
| Feature | Description |
| ------ | ------------------ |
| Maximum Amplitude | the maximum distance between the eye trajectory and eye position when saccade onsets |
| Maximum Velocity | the maximum absolute velocity during saccade |
| Duration | saccade duration |
| Mean Velocity | average of all absolute instantaneous velocity during saccade |
| Q Factor | maximum velocity divided by mean velocity |
| Acceleration Time | time duration from saccade onset to maximum velocity |
| Deceleration Time | time duration from maximum velocity to saccade offset |
| Acc/dec Ratio | acceleration time divided by deceleration time |
| Amplitude | the distance between eye position at saccade onset and eye position at saccade offset |
| Confidence | The average probability during saccade if probability trace is provided. If not, then all set to 1 |
| Start Point X | eye position X at saccade onset |
| Start Point Y | eye position Y at saccade onset |
| Start Point Radius | eye position radius (polar system) at saccade onset |
| End Point X | eye position X at saccade offset |
| End Point Y | eye position Y at saccade offset |
| End Point Radius | eye position radius (polar system) at saccade offset |
| Angle | saccade direction angle |
| Nan Distance | time distance from saccade to the closest nan caused by blink or unstable tracking. If no nan, then all set to 0|
| Trial Start Distance | time distance from saccade to corresponding trial start. If trial information not provided, then all set to 0|
| Trial End Distance | time distance from saccade to corresponding trial end. If trial information not provided, then all set to 0 |
| Saccade Tag | tagging number of saccade. If saccade tag is not provided, then all set to 0 |

To modify the saccade features displayed, you can use the dropdown button located above the feature plot. It allows you to change the X-axis and Y-axis independently. Additionally, you have the option to switch between a linear scale plot and a log scale plot for each axis using the corresponding checkboxes.

Furthermore, you can select which trace to display the saccades from: either the saccade trace or the saccade reference trace. Additionally, you can choose to view all saccades, inclusive saccades only (those that match with another trace's saccade detection), or exclusive saccades only (those not detected by another trace). The mode selection determines which saccades are visible on the plot.

![Outlier Detector](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/outlier_detector.png)

If you wish to view specific saccades on the time trace that correspond to certain positions in the feature space, you can draw a polygonal region of interest (ROI) in the feature space. When selecting and navigating to previous or next saccades on the time trace, the GUI will only take you to saccades that fall within the ROI. This allows you to focus on outlier saccades that are more likely to be misdetections, saving you time. If you're uncertain about how to draw a polygon to capture the outlier saccades, you can use the outlier detection function located at the top of the time trace plot. By clicking the "Detect" button, the GUI will generate an ROI on the current feature space, including outliers, based on the specified outlier percentage indicated by the slider. You can adjust the slider to change the desired outlier percentage. A higher percentage will result in more outliers being included. It's important to note that this percentage may not accurately reflect the actual percentage of saccades within the ROI, as it can be challenging to draw a polygon only including outliers but not others. Use it as a relative reference for controlling the number of outliers. If you're having difficulty choosing features to detect outliers, you can simply click the "Default Detection" button. This will automatically select the best feature space and the optimal outlier percentage for detection. Specifically, if probability is provided, the detection space includes the Acc/Dec Ratio and confidence. If probability is not given, the detection space includes the Acc/Dec Ratio and Q Factor. The default outlier percentage is set at 8%.

To facilitate the feature analysis of the currently selected saccade, a green dot is displayed on the feature space to highlight its position when the selected saccade and the saccades chosen on the feature plot are from the same trace. This makes it easier to visually identify the specific saccade of interest. Additionally, at the upper left corner, a saccade counter provides two numbers: the current saccade's position in the overall saccade set shown in the feature space (Global Saccade Counter) and its position among the saccades within the ROI displayed in the feature space (ROI Saccade Counter). The position of saccade is ordered by time.

Moreover, the feature space keeps track of valid and invalid saccades. If a saccade is too short in duration, contains NaN (Not a Number) values, or crosses trials (if trial information is provided), it is considered invalid and will be labeled as a circle instead of a dot. We recommend curating these invalid saccades before saving your results to ensure data quality.

For instruction on how to draw/cancel roi, zoom in/put and move plot, please see [Instruction Table](#instruction-table) for details.

[back to start](#content)

## <a name="trajectory-module">Trajectory Module</a>

![Trajectory Plot](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/trajectory_plot.png)


The trajectory module is located on the lower right of the main window. It provides visual representation of the eye movement trajectory during the selected saccade, as well as optional visual target information. The features of this module are as follows:

 - Eye Trajectory: The eye movement trajectory is displayed as a curved gray line, with a lighter shade indicating the onset and a darker shade indicating the offset of the saccade.

 - Visual Target (Trial-specific): Optionally, the visual target shown during the specific trial is represented by solid dots. Primary targets are displayed in blue, while secondary targets are displayed in red.

 - Visual Target Layout: Optionally, the overall visual target layout is depicted. The fixation center and primary targets are displayed in purple, while secondary targets are shown in pink.
 
Please note that the module currently assumes a [8-direction primary and secondary target layout](https://www.nature.com/articles/nature15693) for visual target and visual target layout representation.

For instruction on how to zoom in or zoom put, please see [Instruction Table](#instruction-table) for details.

[back to start](#content)

## <a name="prerequisite-environment">Prerequisite Environment</a> 

Only MATLAB is needed. We recommend using a version higher than 2022a for optimal compatibility and performance.

### Tool box requirement:
 -  [Statistics and Machine Learning Toolbox](#https://www.mathworks.com/products/statistics.html)
 
 [back to start](#content)
 
## <a name="data-structure">Data Structure</a> 

![Data Structure Plot](https://github.com/Arueruma1999/SACCURATE/blob/main/illustrations/data_structure_plot.png)

Data input should be a .mat file. The file can be named whatever you prefer, but it should be a struct named as 'eye_movement_data' with following data inside:

### <a name="data-structure-table">Data Structure Table</a> 
| Data | Description |
| ------ | ------------------ |
| X | ***double, size of (sample_point_number, 1)*** X postion of eye trace in this recording |
| Y | ***double, size of (sample_point_number, 1)*** Y postion of eye trace in this recording |
| Frequency | ***double, size of (1, 1)*** sample rate on Hz, we recommend 1000, 2000 or higher |
| Saccade | ***integer, size of (sample_point_number, 1)*** should contain either 1 or 0,  1 for saccade and 0 for non saccade|
| SaccadeReference | ***integer, size of (sample_point_number, 1), optional*** should contain either 1 or 0,  1 for saccade and 0 for non saccade|
| SaccadeTag | ***double, size of (sample_point_number, 1), optional*** should contain 0 and other integers. Other integers indicate the tag for each saccade period, while 0 represents a non-saccade period. Note that saccade period of SaccadeTag should match that of SaccadeReference |
| PrimaryTargetAmplitude | ***double, size of (1, 1), optional*** displacement amplitude for primary target from origin center target, used for layout |
| SecondaryTargetAmplitude | ***double, size of (1, 1), optional*** displacement amplitude for secondary target from primary target, used for layout |
| XOrigin |  ***double, size of (1, 1), optional*** X position for origin center target, used for layout |
| YOrigin |  ***double, size of (1, 1), optional*** Y position for origin center target, used for layout |
| TrialList |  ***double, size of (trial_number, 1), optional*** unique integer numbers array. we recommand it to be 1:1:trial_number|
| XPrimaryTargetForTrial |  ***double, size of (trial_number, 1), optional*** X postion of primary target for each trial corresponding to TrialList|
| YPrimaryTargetForTrial |  ***double, size of (trial_number, 1), optional*** Y postion of primary target for each trial corresponding to TrialList|
| XSecondaryTargetForTrial |  ***double, size of (trial_number, 1), optional*** X postion of secondary target for each trial corresponding to TrialList|
| YSecondaryTargetForTrial |  ***double, size of (trial_number, 1), optional*** Y postion of secondary target for each trial corresponding to TrialList|
| XTarget |  ***double, size of (sample_point_number, 1), optional*** X position of target trace in this recording|
| YTarget |  ***double, size of (sample_point_number, 1), optional*** Y position of target trace in this recording|
| TrialTag |  ***double, size of (sample_point_number, 1), optional*** should only contain integers given from TrialList, indicating which time points belongs to which trial|
| Probability |  ***double, size of (sample_point_number, 1), optional*** should be larger or equal to 0 and smaller or equal to 1, indicating probability of each time point to be in saccade period or not usually given by deep net|
| CurationMetadata | ***struct, size of (1, 1), No need to provide*** this struct keep tract of metadata of when curation is done by which computer. There is a string array named 'curator' keeping track of system name and a string array named 'time' keeping track of curation time. This struct will generate automatically each time curation is saved|

**P.S.** Trial related data, target related data, and SaccadeTag are mostly designed for [This Paradigm](#https://www.nature.com/articles/nature15693). They are optional so you can decide whether to use them depending on you experiment paradigm. If your experiment also uses repetitive loop unit, you can use trial related data to show that information. If your experiment also use quickly changing visual target to induce saccade, you could use target related data to show that information. If your experiment would like to separate saccade detected into different classes, you could use SaccadeTag to show this information.

You can also play with our [demo dataset](https://github.com/Arueruma1999/SACCURATE/blob/main/demo%20dataset/demo_data_59d_2019-11-08_11-45-24.mat) to explore more details. To Use the GUI, simply run [SACCURATE.mlapp](https://github.com/Arueruma1999/SACCURATE/tree/main/GUI) in the GUI folder

[back to start](#content)

## <a name="installation">Installation</a> 

1. Install Matlab with [toolbox required](#prerequisite-environment).

2. Download or clone the Github repository into local directory
```
git clone https://github.com/Arueruma1999/SACCURATE
```
3. Go to GUI subfolder and open SACCURATE using Matlab
```matlab
SACCURATE()
```
4. open [demo_data_59d_2019-11-08_11-45-24.mat](https://github.com/Arueruma1999/SACCURATE/blob/main/demo%20dataset/demo_data_59d_2019-11-08_11-45-24.mat) in demo dataset subfolder using open eye movement file icon in toolbar of SACCURATE and play with it!
	
[back to start](#content)




