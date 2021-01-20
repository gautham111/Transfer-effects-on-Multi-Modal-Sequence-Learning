clear all;

audio1 = readmatrix("one_AudioRT.xls");
visual1 = readmatrix("one_VisualRT.xls");
audio2 = readmatrix("two_AudioRT.xls");
visual2 = readmatrix("two_VisualRT.xls");
audio3 = readmatrix("three_AudioRT.xls");
visual3 = readmatrix("three_VisualRT.xls");

audio = ones(size(audio1));
for i = 1:length(audio1)
    audio(i) = mean([audio1(i,2) audio2(i,2) audio3(i,2)]);
end

visual = ones(size(visual1));
for i = 1:length(visual1)
    visual(i) = mean([visual1(i,2) visual2(i,2) visual3(i,2)]);
end

graph = [];

for i = 1:6
    index = (i-1)*97 + 2;
    arr = []; 
    for j = 1:8
        arr = [arr mean(audio(index:index+11))];
        index = index+12;
    end
    graph = [graph mean(arr)];
end
   
for i = 1:6
    index = (i-1)*97 + 2;
    arr = []; 
    for j = 1:8
        arr = [arr mean(visual(index:index+11))];
        index = index+12;
    end
    graph = [graph mean(arr)];
end

figure;
plot(1:12, graph);