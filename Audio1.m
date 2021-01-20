sca;
close all;
clearvars;

PsychDefaultSetup(2);

rng('shuffle');

screens = Screen('Screens');

screenNumber = max(screens);

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

%PsychDebugWindowConfiguration;

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

Screen('TextSize', window, 33);

[xCenter, yCenter] = RectCenter(windowRect);

[wavedata1 freq] = audioread('1.wav');
[wavedata2] = audioread('2.wav');
[wavedata3] = audioread('3.wav');
[wavedata4] = audioread('4.wav');

validResponseKeys  = [KbName('v') KbName('b') KbName('n') KbName('m')];
validResponseKeyName = 'vbnm';

Screen('DrawText', window, 'Instructions', xCenter-100, yCenter/2, black);
Screen('DrawText', window, 'Press the Key corresponding to the sound', xCenter-250, yCenter, black);
Screen('DrawText', window,'Hit ENTER to continue',xCenter-200, yCenter+150, black);
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

InitializePsychSound(1);
pahandle = PsychPortAudio('Open', [], 1, 1, 48000, 1);
PsychPortAudio('Volume', pahandle, 0.5);

seq1 = [1 2 1 3 4 2 3 1 4 3 2 4];

seq = [];

for j = 1:2
    seq = [seq seq1];
end

Screen('Flip',window);

for i = 1:2
    r = randi(4);
    seqt = [r seq];
    for j = 1:length(seqt)
        switch seqt(j)
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
            if any(keyCode(validResponseKeys(seqt(1,j))))
                PsychPortAudio('Stop', pahandle);
                break;
            end
        end
    end
end
 
PsychPortAudio('Close');
Screen('DrawText', window, 'End of Phase1',xCenter-100,yCenter,black);
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