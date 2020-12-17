function beamidx = assignBeamTDMA(RSS, assign)
beamidx = [];
cN = length(RSS);
for ci = 1:cN
    [~, beamidx(ci)] = max(RSS{ci}(assign(ci), :));
end
end