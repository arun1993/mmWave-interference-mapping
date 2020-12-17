function configtrace(moveSpd, rotateSpd, devSampRate)

global moveStep rotateStep
moveStep = moveSpd/devSampRate;
rotateStep = rotateSpd/devSampRate;
