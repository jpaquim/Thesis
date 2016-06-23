% add the paths of the various modules
addpath Textons
addpath Data-Handling
addpath Features
addpath Classification
addpath Regression
addpath Post-Processing
addpath Optimization
addpath Stereo
addpath Misc

trainDataset = 'ZED-01-raw';
testDataset = 'ZED-03-full';
% TODO: testDataset is always being regenerated when changed, because cfg
% is different between the two datasets.

% structure that contains the configuration of the image, patches, textons
cfg = defaultConfig(trainDataset);

% load or generate the training data set
[trainFeatures,trainDepths,indFilesTrain] = loadData(trainDataset,cfg);

if strcmp(trainDataset,testDataset) % use cross validation on the same set
    proportion = 0.7;
    [trainFeatures,testFeatures,trainDepths,testDepths,...
    indPermTrain,indPermTest] = ...
        validationPartition(trainFeatures,trainDepths,...
        proportion,cfg.nPatches,false);
    indFilesTest = indFilesTrain(indPermTest);
    indFilesTrain = indFilesTrain(indPermTrain);
else % load or generate the test data set
    [testFeatures,testDepths,indFilesTest] = loadData(testDataset,cfg);
end

% TODO: remove invalid depths/disparities
% validInd = findValidDepths(cfg);
% trainValidInd = find(trainDepths >= 0);
% trainFeatures = trainFeatures(trainValidInd,:);
% auxDepth = zeros(size(trainDepths));
% trainDepths = trainDepths(trainValidInd);
% testValidInd = find(testDepths >= 0);
% testFeatures = testFeatures(testValidInd,:);
% testDepths = testDepths(testValidInd);

% normalize the training features to the [0 1] range
[trainFeatures,offset,scale] = normalizeFeatures(trainFeatures);
% normalize the test features using the same offset and scale
testFeatures = normalizeFeatures(testFeatures,offset,scale);

% add a constant column for bias
trainFeatures = [trainFeatures ones(size(trainFeatures,1),1)];
testFeatures = [testFeatures ones(size(testFeatures,1),1)];

cfg.outputType = 'regression'; % uncomment for regression
% cfg.outputType = 'classification'; % uncomment for classification
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
        [model,predTrain,predTest] = classificationModel(...
            trainFeatures,trainLabels,testFeatures,testLabels,modelType);
end
% auxDepth(trainValidInd,:) = predTrain;
% predTrain = auxDepth;
% auxDepth(trainValidInd,:) = trainDepths;
% trainDepths = auxDepth;
% perform post-processing and analysis on the predicted results
processResults(predTrain,trainDepths,indFilesTrain,trainDataset,cfg);
processResults(predTest,testDepths,indFilesTest,testDataset,cfg);
