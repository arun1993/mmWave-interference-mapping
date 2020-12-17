function loadtrace(file)

global tracem1data dataN
tracem1data = load(file);
dataN = size(tracem1data.data{1}, 1);