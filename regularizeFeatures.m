function regFeaturesData = regularizeFeatures(featuresData)
%REGULARIZEFEATURES Summary of this function goes here
%   Detailed explanation goes here

featuresAverage = mean(featuresData);
featuresStdDev = std(featuresData);
regFeaturesData = bsxfun(@minus,featuresData,featuresAverage);
regFeaturesData = bsxfun(@rdivide,regFeaturesData,featuresStdDev);

end