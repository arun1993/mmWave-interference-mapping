
figidx = 1;

f = figure(figidx); figidx = figidx+1; clf(f); hold on
for ii = 1:size(measureTH, 2)
    plot(measureTH(:, ii))
end
title('Throughput over time')
if exist('method', 'var') && ~isempty(method)
    saveas(f, ['figures/' method '_Throughput_time.png']);
end


f = figure(figidx); figidx = figidx+1; clf(f); hold on
for ii = 1:size(measureTH, 2)
    plot(measureAssign(:, ii)+0.05*ii, '*')
end
title('Sender Assignment over time')
if exist('method', 'var') && ~isempty(method)
    saveas(f, ['figures/' method '_Assignment_time.png']);
end

f = figure(figidx); figidx = figidx+1; clf(f); hold on
bar(mean(measureTH))
title('Throughput')
if exist('method', 'var') && ~isempty(method)
    saveas(f, ['figures/' method '_Throughput_bar.png']);
end


f = figure(figidx); figidx = figidx+1; clf(f); hold on
bardata = [];
for ii = 1:size(measureTH, 2)
    bardata(ii) = sum(measureActiveTime(measureTH(:, ii) > 10, ii)) / length(measureTH(:, ii));
end
bar(bardata)
title('Transmit opportunity')
if exist('method', 'var') && ~isempty(method)
    saveas(f, ['figures/' method '_Opportunity_bar.png']);
end


ccrate = sum((measureAssign(:, 1) ~= measureAssign(:, 2)) & measureAssign(:, 1) > 0 & measureAssign(:, 2) > 0& measureTH(:, 1) > 10 & measureTH(:, 2) > 10)/ length(measureTH(:, ii));
disp(['Concurrent transmission percentage: ' num2str(ccrate)]);


if exist('method', 'var') && ~isempty(method)
save(['resultdata/' method '.mat'], 'measureTH', 'measureAssign', 'ccrate');
end

