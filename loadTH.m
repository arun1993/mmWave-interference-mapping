function loadTH(tracem2S1, tracem2S2, tracem2S3)

global traces1 traces1N traces2 traces2N traces3 traces3N

traces1 = load(tracem2S1);
traces1N = size(traces1.data{1}, 1);

traces2 = load(tracem2S2);
traces2N = size(traces2.data{2}, 1);

traces3 = load(tracem2S3);
traces3N = size(traces3.data{3}, 1);


