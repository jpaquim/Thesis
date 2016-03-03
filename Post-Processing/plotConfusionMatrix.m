function confMat = plotConfusionMatrix(labels,predictedLabels,nClasses)
%PLOTCONFUSIONMATRIX Summary of this function goes here
%   Detailed explanation goes here

confMat = confusionmat(labels,predictedLabels,'order',1:10)';
% plotconfusion funtion needs data in binary form
labelsBin = convertToBinClasses(labels',nClasses);
predictedBin = convertToBinClasses(predictedLabels',nClasses);
plotconfusion(labelsBin,predictedBin);
end