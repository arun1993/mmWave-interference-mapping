function MCS = maptoMCS(SIR)

MCS = zeros(length(SIR), 8);
SIRm = [-inf 4 6 8 10 12 14 16 18 20 22 24];
% SIRm = [-inf 4 6 8 10 12 14 16 18 20 22 24]*2;
MCSm = [-1 0 1 2 3 4 6 7 8 10 11 12];
for si = 1:length(SIR)
MCS(si, 8) = MCSm(find(SIRm < SIR(si), 1, 'last'));
end