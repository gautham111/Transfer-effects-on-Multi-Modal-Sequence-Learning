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

Screen('TextSize', window, 42);

[xCenter, yCenter] = RectCenter(windowRect);

[wavedata1 freq] = audioread('1.wav');
[wavedata2] = audioread('2.wav');
[wavedata3] = audioread('3.wav');
[wavedata4] = audioread('4.wav');

validResponseKeys  = [KbName('v') KbName('b') KbName('n') KbName('m')];
validResponseKeyName = [1 2 3 4];

fblocknum = 6;
blocknum = 6;
seqnum = 8;

Screen('DrawText', window, 'Instructions', xCenter-100, yCenter-250, black);
Screen('DrawText', window, 'Press the Key corresponding to the sound', xCenter-300, yCenter-50, black);
Screen('DrawText', window, 'You will be given feedback on whether you pressed the correct key,',xCenter-500, yCenter, black);
Screen('DrawText', window, 'then it will automatically play the next sound',xCenter-300,yCenter+50,black);
Screen('DrawText', window,'Hit ENTER to continue',xCenter-190, yCenter+100, black);
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
RT = [];
correct_response = [];
block = [];
waitTime = ones(size(1,blocknum));

for j = 1:seqnum
    seq = [seq seq1];
end

for i = 1:fblocknum
    seqt = randperm(4);
    for j = 1:4
        Screen('Flip', window);
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
                Screen('DrawText', window, 'Correct',xCenter-100,yCenter,[0 1 0]);
                Screen('Flip', window);
                WaitSecs(1);
                break;
            elseif any(keyCode(validResponseKeys))
                PsychPortAudio('Stop', pahandle);
                Screen('DrawText', window, 'Incorrect', xCenter-100,yCenter,[1 0 0]);
                Screen('Flip', window);
                WaitSecs(1);
                break;
            end      
        end
    end
end

Screen('DrawText', window, 'You will no longer recieve feedback',xCenter-300,yCenter,black);
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

for i = 1:blocknum
    WaitSecs(0.07);
    r = randi(4);
    seqt = [r seq];
    block = [block i*ones(size(seqt))];
    Screen('Flip',window);
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
            [~, stopTime, keyCode] = KbCheck;
            if any(keyCode(KbName('ESCAPE')) || keyCode(KbName('q')))
                PsychPortAudio('Stop', pahandle);
                PsychPortAudio('Close');
                sca;
                error('User quit.');
            end
            if any(keyCode(validResponseKeys(seqt(j))))
                startTime = PsychPortAudio('Stop', pahandle);
                RT = [RT (stopTime-startTime)*1000];
                correct_response = [correct_response validResponseKeyName(seqt(j))];
                break;
            end
        end
    end
    Screen('DrawText', window, 'BREAK - Press Enter to Continue and q to quit.',xCenter-250,yCenter,black);
    startTime = Screen('Flip', window);
    while (1)
        [~, stopTime, keyCode] = KbCheck;
        if any(keyCode(KbName('return')))
            waitTime(i) = stopTime - startTime;
            WaitSecs(0.7);
            break;
        end
        if any(keyCode(KbName('q')))
            sca;
            error('User quit!');
        end
    end
end

PsychPortAudio('Close');
writematrix([block' RT' correct_response'],strcat(subjectID,'_AudioRT.xls'));
Screen('DrawText', window, 'End of Part2',xCenter-100,yCenter,black);
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