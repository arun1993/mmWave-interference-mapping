function RSSdata = convertRSS(RSS)
RSSdata = {};
cN = length(RSS);
sN = size(RSS{1}, 1);
for APi = 1:sN
    RSSdata_ = [];
    for Clienti = 1:cN
        RSSdata_ = [RSSdata_ RSS{Clienti}(APi, :).'];
    end
    RSSdata{APi} = RSSdata_;
end
end