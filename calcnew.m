clear all;

audio1 = readmatrix("five_AudioRT.xls");
visual1 = readmatrix("five_VisualRT.xls");

graph = [];

RT = zeros(1,4);
n = zeros(1,4);

for i = 1:length(audio1)
    RT(audio1(i,3)) = RT(audio1(i,3)) + audio1(i,2);
    n(audio1(i,3)) = n(audio1(i,3)) + 1;
end

for i = 1:4
    RT(i) = RT(i)/n(i);
end

for i = 1:6
    index = (i-1)*97 + 2;
    arr = []; 
    for j = 1:8
        arr = [arr mean(audio1(index:index+11,2))];
        index = index+12;
    end
    graph = [graph mean(arr)];
end
   
for i = 1:6
    index = (i-1)*97 + 2;
    arr = []; 
    for j = 1:8
        arr = [arr mean(visual1(index:index+11,2))];
        index = index+12;
    end
    graph = [graph mean(arr)];
end

figure;
plot(1:12, graph);
figure;
plot(1:4,RT);