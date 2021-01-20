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

Screen('DrawText', window, 'Instructions', xCenter-110, yCenter-100, black);
Screen('DrawText', window, 'Press the Key shown on screen and notice the sound', xCenter-300, yCenter, black);
Screen('DrawText', window,'Hit ENTER to continue',xCenter-190, yCenter+50, black);
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

InitializePsychSound(1);
pahandle = PsychPortAudio('Open', [], 1, 1, 48000, 1);
PsychPortAudio('Volume', pahandle, 0.5);

for i = 1:9
    seq = randperm(4);
    for j = 1:4
        WaitSecs(0.3);
        Screen('DrawText', window, validResponseKeyName(seq(1,j)),xCenter-50,yCenter,black);
        Screen('Flip', window);
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
        while (1)
            [~, ~, keyCode] = KbCheck;
            if any(keyCode(KbName('ESCAPE')) || keyCode(KbName('q')))
                PsychPortAudio('Stop', pahandle);
                PsychPortAudio('Close');
                sca;
                error('User quit.');
            end
            if any(keyCode(validResponseKeys(seq(1,j))))
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