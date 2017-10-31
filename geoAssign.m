function [APassign, bestBeam, BeamM] = geoAssign(RSSin)

ClientN = length(RSSin);
APN = size(RSSin{1}, 1);

RSSdata = convertRSS(RSSin);
% tic
APassign = [];
for Clienti = 1:ClientN
    minRSS = [];
    for APi = 1:APN
        minRSS(APi) = prctile(RSSdata{APi}(:, Clienti), 10);
    end
    [~, maxidx] = max(minRSS);
    APassign(Clienti) = maxidx;
end

group = unique(APassign);
groupN = length(group);
BeamM = size(RSSdata{1}, 1);
ClientN = size(RSSdata{1}, 2);

bestBeam = zeros(1, ClientN);
for Clienti = 1:ClientN
    LeakStr = zeros(BeamM, groupN);
    APi = APassign(Clienti);
    SigStr = RSSdata{APi}(:, Clienti);
    for groupi = 1:groupN
        if group(groupi) ~= APassign(Clienti)
            LeakStr(:, groupi) = max(RSSdata{APi}(:, APassign == group(groupi)), [], 2);
        end
    end
    SLR = 10*log10(repmat(SigStr, 1, groupN)./LeakStr);
    % method 1: maximize min
    [~, bestBeam_] = max(min(SLR(:, group ~= APassign(Clienti)), [], 2));
    % method 2: maximize mean
%     [~, bestBeam_] = max(mean(SLR(:, group ~= APassign(Clienti)), 2));
    if isempty(bestBeam_)
        bestBeam_ = assignBeamTDMA(RSSin, APassign);
        bestBeam_ = bestBeam_(Clienti);
    end
    bestBeam(1, Clienti) = bestBeam_;
end
% toc

end