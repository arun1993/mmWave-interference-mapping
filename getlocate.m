function d = getlocate(HeadsetID)

senderID = 1;
global tracem1data moveStep rotateStep dataN 
persistent HeadsetIdx dataNall

if isempty(HeadsetIdx)
    HeadsetIdx = round((0:2)*dataN/3)+1;
    dataNall = round((1:3)*dataN/3);
    
    idx = HeadsetIdx(HeadsetID);
    d = [];
    for sii = 1:length(senderID)
        d(sii, :) = tracem1data.data{senderID(sii)}(idx, :);
    end
else
idx = HeadsetIdx(HeadsetID);
dataEndN = dataNall(HeadsetID);

    stepL = 50;
    if idx + stepL > dataEndN
        stepL = dataEndN - idx;
        if stepL < 5
            d = [];
            return
        end
    end
    while true
        loc_rotate = tracem1data.data{senderID(1)}(idx+1:idx+stepL, 1:5);
        dist = cumsum(sqrt(diff(loc_rotate(:, 1)).^2+diff(loc_rotate(:, 2)).^2+diff(loc_rotate(:, 3)).^2));
        validmove = find(dist >= moveStep(1) & dist <= moveStep(2));
        rot = (cumsum(sqrt(diff(unwrap(deg2rad(loc_rotate(:, 4)))).^2 + diff(deg2rad(loc_rotate(:, 5))).^2)));
        validrot = find(rot >= rotateStep(1) & rot <= rotateStep(2));
        validstep = unique([validmove; validrot]);
        if ~isempty(validstep)
            i = randsample(validstep, 1, false);
            idx = idx + i;
            d = [];
            for sii = 1:length(senderID)
                d(sii, :) = tracem1data.data{senderID(sii)}(idx, :);
            end
            HeadsetIdx(HeadsetID) = idx;
            return;
        elseif dist(end) >= moveStep(1) || rot(end) >= rotateStep(1)
            validmove = find(dist >= moveStep(1));
            validrot = find(rot >= rotateStep(1));
            validstep = unique([validmove(1); validrot(1)]);
            i = randsample(validstep, 1, false);
            idx = idx + i;
            d = [];
            for sii = 1:length(senderID)
                d(sii, :) = tracem1data.data{senderID(sii)}(idx, :);
            end
            HeadsetIdx(HeadsetID) = idx;
            return;
        elseif idx + stepL < dataEndN
            stepL = stepL*2;
            if idx + stepL > dataEndN
                stepL = dataEndN - idx;
            end
        else
            d = [];
            return;
        end
    end
end

end
