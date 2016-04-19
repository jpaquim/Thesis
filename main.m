% add the paths of the various modules
addpath Textons
addpath DataLoadGen
addpath FeatureExtraction
addpath Classification
addpath Regression
addpath Post-Processing
addpath Optimization
addpath OnlineLearning
addpath StereoMatching
addpath Misc

trainDataset = 'NYUTrain';
testDataset = 'NYUTest';

% structure that contains the configuration of the image, patches, textons
cfg = defaultConfig(trainDataset);

% load the training data set
[trainFeatures,trainDepths,indFilesTrain] = loadData(trainDataset,cfg);
% load the test data set
[testFeatures,testDepths,indFilesTest] = loadData(testDataset,cfg);

% normalize the training features to the [0 1] range
[trainFeatures,offset,scale] = normalizeFeatures(trainFeatures);
% normalize the test features using the same offset and scale
testFeatures = normalizeFeatures(testFeatures,offset,scale);

% add a constant column for bias
trainFeatures = [trainFeatures ones(size(trainFeatures,1),1)];
testFeatures = [testFeatures ones(size(testFeatures,1),1)];

cfg.outputType = 'regression';
% cfg.outputType = 'classification';
modelType = 'calibrated ls';
% train the supervised learning model
switch cfg.outputType
    case 'regression'
        [model,predTrain,predTest] = regressionModel(trainFeatures,...
            trainDepths,testFeatures,modelType);
    case 'classification'
%         number of classes used in the depth labeling
        cfg.nClasses = 10;
%         types of interval spacing: 'lin' for linear, 'log' for
%          logarithmic, 'opt' for optimal, uniform histogram over classes
        cfg.classType = 'opt';
%         generate interval edges and centers
        [cfg.classEdges,cfg.classCenters] = ...
            depthIntervals(trainDepths,cfg.nClasses,cfg.classType);
%         label the depth data into discrete classes
        trainLabels = labelDepths(trainDepths,cfg.classEdges);
        testLabels = labelDepths(testDepths,cfg.classEdges);
        [model,predTrain,predTest] = classificationModel(trainFeatures,...
            trainLabels,testFeatures,testLabels,modelType);
end
% perform post-processing and analysis on the predicted results
processResults(predTrain,trainDepths,indFilesTrain,trainDataset,cfg);
processResults(predTest,testDepths,indFilesTest,testDataset,cfg);
