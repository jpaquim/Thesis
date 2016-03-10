function J = costFunctionParameters(parameterVec)
%COSTFUNCTIONREGULARIZATION Summary of this function goes here
%   Detailed explanation goes here

cfg = defaultConfig();
cfg = updateConfig(cfg,parameterVec);

[trainFeatures,trainDepths,trainLabels] = ...
    loadData('training',cfg);
trainFeatures = normalizeFeatures(trainFeatures);
trainFeatures = [trainFeatures ones(length(trainLabels),1)];

% partition the training data for validation using the holdout method
[trainFeatures,testFeatures,trainDepths,testDepths] = ...
    validationPartition(trainFeatures,trainDepths,proportion);

outputType = 'regression';
modelType = 'calibrated ls';
% train the supervised learning model
if strcmp(outputType,'regression');
    [~,~,predTest] = regressionModel(trainFeatures,...
        trainDepths,testFeatures,modelType);
else
    [~,~,predTest] = classificationModel(trainFeatures,...
        trainLabels,testFeatures,testLabels,modelType);
end
% evaluate performance metrics on the test set
[~,~,J,~] = performanceMetrics(predTest,testDepths,'test');
end