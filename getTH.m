function th = getTH(d, selSender)
th = [];
for ii = 1:length(selSender)
    th(ii) = getTH_(d(ii, :), selSender(ii));
end
for ii = 1:length(selSender)
    th(ii) = th(ii)/sum(selSender == selSender(ii));
end
end

function th = getTH_(d, activeSender)

global traces1 traces1N traces2 traces2N traces3 traces3N
persistent thidx1 thidx2 thidx3
if isempty(thidx1)
    thidx1 = 0;
    thidx2 = 0;
    thidx3 = 0;
end

if activeSender == 1
    traceTH = traces1;
    traceTHN = traces1N;
    thidxTH = thidx1;
elseif activeSender == 2
    traceTH = traces2;
    traceTHN = traces2N;
    thidxTH = thidx2;
elseif activeSender == 3
    traceTH = traces3;
    traceTHN = traces3N;
    thidxTH = thidx3;
else
    error('outside')
end

targetMCS = d(8);
th = 0;
if sum(d) == 0
    th = prctile(traceTH.data{activeSender}(:, 14), 10);
end
while th < 5
    if targetMCS == -1
        th = 5;
        break;
    end
    for thidx = thidxTH+1:traceTHN
        if traceTH.data{activeSender}(thidx, 8) == targetMCS
            th = traceTH.data{activeSender}(thidx, 14);
            thidxTH = thidx;
            break;
        end
    end
    if th < 5
        for thidx = 1:thidxTH
            if traceTH.data{activeSender}(thidx, 8) == targetMCS
                th = traceTH.data{activeSender}(thidx, 14);
                thidxTH = thidx;
                break;
            end
        end
    end
end
if th < 5
    error('fail to get throughput');
end

if activeSender == 1
    thidx1 = thidxTH;
elseif activeSender == 2
    thidx2 = thidxTH;
elseif activeSender == 3
    thidx3 = thidxTH;
else
    error('outside')
end

end