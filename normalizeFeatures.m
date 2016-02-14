function normFeaturesData = normalizeFeatures(featuresData)
%NORMALIZEFEATURES Summary of this function goes here
%   Detailed explanation goes here

featuresAverage = mean(featuresData);
featuresStdDev = std(featuresData);
normFeaturesData = bsxfun(@minus,featuresData,featuresAverage);
normFeaturesData = bsxfun(@rdivide,normFeaturesData,featuresStdDev);

end