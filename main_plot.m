
clc; clear all;

method = {'CSMA', 'TDMA', 'GEO'};
colorall = {'r', 'g', 'b', 'black', 'cyan', 'magenta'};
mark = {'square', '<', 'o', '.', '^', '*'};
figIdx = 1;

data = {};
for midx = 1:length(method)    
    data{midx} = load(['resultdata/' method{midx} '.mat']);    
end

f = figure(figIdx); figIdx = figIdx+1; clf(f); hold on;
bardata = [];
for midx = 1:length(method)
    bardata(midx) = data{midx}.ccrate;
end
[bardata, idx] = sort(bardata);
bar(bardata)
set(gca, 'XTick', 1:3, 'XTickLabel', strrep(method(idx), '_', ''));
title('Concurrent opportunity')
ylabel('Percentage')
saveas(f, 'resultdata/Fig_Concurrent_Opportunity.png');