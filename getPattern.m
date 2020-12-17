function RSS = getPattern(ang, dist)

persistent RSSall minRSS
if isempty(RSSall)
    %RSSall = load('data/RSSPattern.mat');
    RSSall = load('data/sectorpattern_3d_ap.mat');
    minRSS = min(min(RSSall.pattern_rssi));
end

% if ang > 87 || ang < -87
%     RSS = repmat(minRSS, 1, 31);
% else
%     angidx = round(ang/3)+30;
%     RSS = RSSall.pattern_rssi(angidx, :);
%     RSS = RSS/dist^2;
% end
end