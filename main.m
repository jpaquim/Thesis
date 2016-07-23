% add the paths of the various modules
addpath Textons
addpath Data-Handling
addpath Features
addpath Classification
addpath Regression
addpath Post-Processing
addpath Optimization
addpath Stereo

trainDataset = 'Make3D-train';%'ZED-12-raw'; %'HEIGHT-train';%
testDataset = 'Make3D-train'; %'ZED-12-raw'; %'HEIGHT-test';%
% TODO: testDataset is always being regenerated when changed, because cfg is
% different between the two datasets.

% structure that contains the configuration of the image, patches, textons
cfg = defaultConfig(trainDataset);

% load or generate the training data set
[trainFeatures,trainDepths,trainFileNumbers] = loadData(trainDataset,cfg);

if strcmp(trainDataset,testDataset) % use cross validation on the same set
    proportion = 0.7;
    [trainFeatures,testFeatures,trainDepths,testDepths,...
    trainIndPerm,testIndPerm] = ...
        validationPartition(trainFeatures,trainDepths,...
        proportion,cfg.nPatches,false);
    testFileNumbers = trainFileNumbers(testIndPerm);
    trainFileNumbers = trainFileNumbers(trainIndPerm);
else % load or generate the test data set
    [testFeatures,testDepths,testFileNumbers] = loadData(testDataset,cfg);
end

% filter out low confidence patches, to avoid learning wrong ground truths
confidenceThreshold = 0.1;
[trainFeatures,trainDepths,trainValidPatches] = filterByConfidence(...
    trainFeatures,trainDepths,trainFileNumbers,confidenceThreshold,cfg);
% [testFeatures,testDepths,testValidPatches] = filterByConfidence(...
%     testFeatures,testDepths,testFileNumbers,confidenceThreshold,cfg);

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
        [model,trainPredictions,testPredictions] = ...
            regressionModel(trainFeatures,trainDepths,testFeatures,modelType);
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
        [model,trainPredictions,testPredictions] = classificationModel(...
            trainFeatures,trainLabels,testFeatures,testLabels,modelType);
end

% rebuild the full depth maps for plotting, using ones as placeholders in
% low-confidence patches
trainAuxDepths = ones(cfg.nPatches*length(trainFileNumbers),1);
trainAuxDepths(trainValidPatches,:) = trainPredictions;
trainPredictions = trainAuxDepths;
trainAuxDepths(trainValidPatches,:) = trainDepths;
trainDepths = trainAuxDepths;
% testAuxDepths = ones(cfg.nPatches*length(testFileNumbers),1);
% testAuxDepths(testValidPatches,:) = testPredictions;
% testPredictions = testAuxDepths;
% testAuxDepths(testValidPatches,:) = testDepths;
% testDepths = testAuxDepths;

% perform post-processing and analysis on the predicted results
processResults(trainPredictions,trainDepths,trainFileNumbers,trainDataset,cfg);
processResults(testPredictions,testDepths,testFileNumbers,testDataset,cfg);
