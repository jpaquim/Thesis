function confMat = plotConfusionMatrix(labels,predictedLabels)
%PLOTCONFUSIONMATRIX Summary of this function goes here
%   Detailed explanation goes here

confMat = confusionmat(labels,predictedLabels);
% plotconfusion funtion needs data in binary form
nClasses = 10;
labelsBin = convertToBinClasses(labels,nClasses);
predictedBin = convertToBinClasses(predictedLabels,nClasses);
plotconfusion(labelsBin,predictedBin);
end