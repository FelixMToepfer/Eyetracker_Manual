 %% Set up your experiment
% Clear the workspace and the screen
sca;
close all;
clearvars;

% Setup PTB with some default values
%PsychDefaultSetup(2);

% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;

% Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 2);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'VisualDebugLevel', 3);
% Open the screen
[window, windowRect]=Screen('OpenWindow',screenNumber, 0,[],32,2,[],8);


%% Set up the Eyetracker connection and calibration
SetUp_Eyetracker(window, windowRect(3), windowRect(4))
 
%% Prepare stimulus information and present

% Dimension of the region where will draw the Gabor in pixels
gaborDimPix = windowRect(4) / 2;

% Sigma of Gaussian
sigma = gaborDimPix / 7; 
 
% Orientations of Gabor
orientations=[0 90 135];
 
%Start Eyetracker 
Start_Eyetracker;

for n=1:3
    % Obvious Parameters
    orientation = orientations(n);
    contrast = 0.8;
    aspectRatio = 1.0;
    phase = 0;

    % Spatial Frequency (Cycles Per Pixel)
    % One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
    numCycles = 5;
    freq = numCycles / gaborDimPix;

    % Build a procedural gabor texture (Note: to get a "standard" Gabor patch
    % we set a grey background offset, disable normalisation, and set a
    % pre-contrast multiplier of 0.5.
    % For full details see:
    % https://groups.yahoo.com/neo/groups/psychtoolbox/conversations/topics/9174
    backgroundOffset = [0.5 0.5 0.5 0.0];
    disableNorm = 1;
    preContrastMultiplier = 0.5;
    gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, [],...
        backgroundOffset, disableNorm, preContrastMultiplier);

    % Randomise the phase of the Gabors and make a properties matrix.
    propertiesMat = [phase, freq, sigma, contrast, aspectRatio, 0, 0, 0];


    %------------------------------------------
    %    Draw stuff - button press to exit
    %------------------------------------------

    % Draw the Gabor. By default PTB will draw this in the center of the screen
    % for us.
    Screen('DrawTextures', window, gabortex, [], [], orientation, [], [], [], [],...
        kPsychDontDoRotation, propertiesMat');

    % Flip to the screen
    Screen('Flip', window);
    
    % Right after the Flip send a message to the eye tracker to write a
    % reference in the recorded *.edf file (time delay ~0.00001s)
    Eyelink('Message', 'TRIALID %d', n);
    
    
    % Wait for a button press to present the next stimulus
    KbWait;
    % give some waiting time to allow for subsequent presentations
    WaitSecs(0.1);
    
end
    
End_Eyetracker;
% Clear screen
sca; 