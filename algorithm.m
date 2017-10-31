clc; clear all;

RSSdata = {};
for Clienti = 1:7
    RSSdata_ = [];
    for APi = 1:3
        data = load(sprintf('/home/teng/Dropbox/Robust60GHzNet/expe/multiPlayer/client_beam assignment algorithm/RSS_data_loc%d_AP%d.mat', Clienti, APi));
        RSSdata_ = [RSSdata_; data.RSS.'];
    end
    RSSdata{Clienti} = RSSdata_;
end

RSSdata
[APassign, bestBeam, BeamM] = geoAssign(RSSdata);

APassign
bestBeam
bestBeam = bestBeam + '0' -1;
bestBeam(bestBeam>'9') = bestBeam(bestBeam>'9')+7;
s = char(bestBeam);
base2dec(s, BeamM)

% m1: 9428813656
% 11    20    11    20    23    20     8
% m2: 9439883105
% 11    20    23    20    10    10     8
