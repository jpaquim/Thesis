% add the paths of the various modules
addpath('./Textons');
addpath('./DataLoadGen');
addpath('./FeatureExtraction');
addpath('./Classification');
addpath('./Regression');
addpath('./Post-Processing');
addpath('./Optimization');
addpath('./OnlineLearning');
addpath('./Misc');

trainDataset = 'Make3D';
testDataset = 'NYU';

% structure that contains the configuration of the image, patches, textons
cfgTrain = defaultConfig(trainDataset);
cfgTest = defaultConfig(testDataset);

trainDataType = ['train' trainDataset];
testDataType = ['test' testDataset];

% load the training data set
[trainFeatures,trainDepths,trainLabels,indFilesTrain] = ...
    loadData(trainDataType,cfgTrain);
% load the test data set
[testFeatures,testDepths,testLabels,indFilesTest] = ...
    loadData(testDataType,cfgTest);

% normalize the training features to the [-1 1] range
[trainFeatures,offset,scale] = normalizeFeatures(trainFeatures);
% normalize the test features using the same offset and scale
testFeatures = normalizeFeatures(testFeatures,offset,scale);
% add a constant column for bias
trainFeatures = [trainFeatures ones(size(trainFeatures,1),1)];
testFeatures = [testFeatures ones(size(testFeatures,1),1)];
% return;
outputType = 'regression';
modelType = 'calibrated ls';
% train the supervised learning model
if strcmp(outputType,'regression');
    [model,predTrain,predTest] = regressionModel(trainFeatures,...
        trainDepths,testFeatures,modelType);
else
    [model,predTrain,predTest] = classificationModel(trainFeatures,...
        trainLabels,testFeatures,testLabels,modelType);
end
% perform post-processing and analysis on the predicted results
processResults(predTrain,trainDepths,trainLabels,...
               indFilesTrain,trainDataType,outputType,cfgTrain);
% processResults(predTest,testDepths,testLabels,...
%                indFilesTest,testDataType,outputType,cfgTest);
