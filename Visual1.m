sca;
close all;
clearvars;

PsychDefaultSetup(2);

rng('shuffle');

screens = Screen('Screens');

screenNumber = max(screens);

SubjectID = inputdlg('Subject ID?', 'Experiment');
subjectID = SubjectID{1};

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

%PsychDebugWindowConfiguration;

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

[screenXpixels, screenYpixels] = Screen('WindowSize', window);

[xCenter, yCenter] = RectCenter(windowRect);

validResponseKeys  = [KbName('v') KbName('b') KbName('n') KbName('m')];
validResponseKeyName = [1 2 3 4];

baseRect = [0 0 200 200];

squareXpos = [screenXpixels * 0.20 screenXpixels * 0.4 screenXpixels * 0.6 screenXpixels*0.8];
numSquares = length(squareXpos);

allColors = [0 0 0 0; 0 0 0 0; 0 0 0 0];

allRects = nan(4, 4);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

penWidthPixels = 6;

blocknum = 6;
seqnum = 8;

theImage = imread('~/Pictures/inst.png');
imageTexture = Screen('MakeTexture', window, theImage);

Screen('TextSize', window, 42 );
Screen('DrawTexture', window, imageTexture);
Screen('Flip', window);

while (1)
    [~, ~, keyCode] = KbCheck;
    if any(keyCode(KbName('return')))
        break;
    end
    if any(keyCode(KbName('q')))
        sca;
        error('User quit!');
    end
end

seq1 = [1 2 1 3 4 2 3 1 4 3 2 4];

seq = [];
RT = [];
block = [];
correct_response = [];
errors = [];
waitTime = ones(size(1,blocknum));

for j = 1:seqnum
    seq = [seq seq1];
end

for i = 1:blocknum
    r = randi(4);
    seqt = [r seq];
    block = [block i*ones(size(seqt))];
    for j = 1:length(seqt)
        Screen('FillRect', window, [1 1 0], allRects(:,seqt(j)));
        Screen('FillOval', window, [0 0 0], allRects(:,seqt(j)),max(baseRect));
        Screen('FrameRect', window, allColors, allRects, penWidthPixels);
        error = 0;
        startTime = Screen('Flip', window);   
        while (1)
            [k, stopTime, keyCode] = KbCheck;
            if any(keyCode(KbName('ESCAPE')) || keyCode(KbName('q')))
                sca;
                error('User quit.');
            end
            if any(keyCode(validResponseKeys))
                if any(keyCode(validResponseKeys(seqt(j))))
                    RT = [RT (stopTime-startTime)*1000];
                    correct_response = [correct_response validResponseKeyName(seqt(j))];
                    errors = [errors error];
                    break;
                elseif k 
                    error = error + 1;
                end
            end
        end
    end
    Screen('DrawText', window, 'BREAK - Press Enter to Continue and q to quit.',xCenter-250,yCenter,black);
    startTime = Screen('Flip', window);
    while (1)
        [~, stopTime, keyCode] = KbCheck;
        if any(keyCode(KbName('return')))
            waitTime(i) = stopTime - startTime;
            break;
        end
        if any(keyCode(KbName('q')))
            sca;
            error('User quit!');
        end
    end
end

writematrix([block' RT' correct_response' errors'],strcat(subjectID,'_VisualRT.xls'));
Screen('DrawText', window, 'End of Experiment',xCenter-100,yCenter,black);
Screen('Flip', window);
while (1)
    [~, ~, keyCode] = KbCheck;
    if any(keyCode(KbName('return')))
        break;
    end
    if any(keyCode(KbName('q')))
        sca;
        error('User quit!');
    end
end

sca;