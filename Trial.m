% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

rng('shuffle');

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 200 200];

% Screen X positions of our three rectangles
squareXpos = [screenXpixels * 0.20 screenXpixels * 0.4 screenXpixels * 0.6 screenXpixels*0.8];
numSquares = length(squareXpos);

% Set the colors to Red, Green and Blue
allColors = [0 0 0 0; 0 0 0 0; 0 0 0 0];

% Make our rectangle coordinates
allRects = nan(4, 4);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% Pen width for the frames
penWidthPixels = 6;

%keymap = 

for j = 1:6
    i = randi(4);
    Screen('FillRect', window, [1 1 0], allRects(:,i));
    Screen('FillOval', window, [0 0 0], allRects(:,i),max(baseRect));
        
    % Draw the rect to the screen
    Screen('FrameRect', window, allColors, allRects, penWidthPixels);

    % Flip to the screen
    Screen('Flip', window);

    % Wait for a key press
 %   while(1)
 %       [~, ~, keyCode] = KbCheck;
 %       if any(keyCode
    KbStrokeWait;
    
    i = i + 1;
end

% Clear the screen
sca;