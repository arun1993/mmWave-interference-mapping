%%%% trace specific
senderN = 3; % sender number

tracem1 = 'data/datam1_20170131205805.mat';
tracem2S1 = 'data/datam2_20170125173425_S1.mat';
tracem2S2 = 'data/datam2_20170125173756_S2.mat';
tracem2S3 = 'data/datam2_20170125174133_S3.mat';

%%%% Headset specific
moveSpd = [0.2 0.4]; % meter/second
rotateSpd = deg2rad([30 60]); % rad/second
devSampRate = 10; % device samples/second

%%%% load data
loadtrace(tracem1);
configtrace(moveSpd, rotateSpd, devSampRate);
loadTH(tracem2S1, tracem2S2, tracem2S3);