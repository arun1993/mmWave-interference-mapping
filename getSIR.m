function SIR = getSIR(RSS, assign, beamidx)
cN = length(RSS);
SIR = zeros(cN, 1);
if isempty(beamidx)
    beamidx = assignBeamTDMA(RSS, assign);
end

for ci = 1:cN
    STR = 0;
    ITF = 0;
    for pi = 1:cN
        if pi == ci
            STR = STR + RSS{ci}(assign(ci), beamidx(ci));
        elseif assign(ci) ~= assign(pi)
            ITF = ITF + RSS{ci}(assign(pi), beamidx(pi));
        end
    end
    SIR(ci) = STR/ITF; 
end

end
