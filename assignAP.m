function assign = assignAP(LOS)

[~, idx] = sort(sum(LOS));
assign = [];

for ii = 1:size(LOS, 2)
    c = setdiff(find(LOS(:, idx(ii))), assign);
    if isempty(c)
        c = find(LOS(:, idx(ii)));
    end
    if isempty(c)
        c = 1;
    end
    if length(c) > 1
        assign(ii) = randsample(c, 1, false);
    else
        assign(ii) = c;
    end
end
