sca;
close all;
clearvars;

PsychDefaultSetup(2);

rng('shuffle');

screens = Screen('Screens');

screenNumber = max(screens);

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

%PsychDebugWindowConfiguration();

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

[xCenter, yCenter] = RectCenter(windowRect);

[wavedata1 freq] = audioread('1.wav');
[wavedata2] = audioread('2.wav');
[wavedata3] = audioread('3.wav');
[wavedata4] = audioread('4.wav');

validResponseKeys  = [KbName('v') KbName('b') KbName('n') KbName('m')];
validResponseKeyName = '1234';

theImage = imread('~/Pictures/associnst.png');
imageTexture = Screen('MakeTexture', window, theImage);

Screen('TextSize', window, 42 );
Screen('DrawTexture', window, imageTexture);
Screen('Flip', window);

% Wait for pressing <return> key
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

seq = [1 2 3 4];

InitializePsychSound(1);
pahandle = PsychPortAudio('Open', [], 1, 1, 48000, 1);
PsychPortAudio('Volume', pahandle, 0.5);

for i = 1:11
    for j = 1:4
        switch seq(j)
            case 1
                Screen('DrawText', window, 'X', xCenter, yCenter, [1 0 0]);
            case 2
                Screen('DrawText', window, 'X', xCenter, yCenter, [0 1 0]);
            case 3
                Screen('DrawText', window, 'X', xCenter, yCenter, [0 0 1]);
            otherwise
                Screen('DrawText', window, 'X', xCenter, yCenter, [1 0 1]);
        end
        Screen('Flip',window);
        while (1)
            [~, ~, keyCode] = KbCheck;
            if any(keyCode(KbName('ESCAPE')) || keyCode(KbName('q')))
                PsychPortAudio('Close');
                sca;
                error('User quit.');
            end
            if any(keyCode(validResponseKeys(seq(1,j))))
                switch seq(j)
                    case 1
                        PsychPortAudio('FillBuffer', pahandle, wavedata1');
                    case 2
                        PsychPortAudio('FillBuffer', pahandle, wavedata2');
                    case 3
                        PsychPortAudio('FillBuffer', pahandle, wavedata3');
                    otherwise
                        PsychPortAudio('FillBuffer', pahandle, wavedata4');
                end
                PsychPortAudio('Start', pahandle, 1, 0, 1);
                WaitSecs(0.4);
                PsychPortAudio('Stop', pahandle);
                break;
            end
        end
    end
end
PsychPortAudio('Close');
Screen('DrawText', window, 'End of Part1',xCenter-20,yCenter,black);
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