% add the paths of the various modules
addpath Textons
addpath Data-Handling
addpath Features
addpath Classification
addpath Regression
addpath Post-Processing
addpath Optimization

% possible datasets - KITTI2012-train, KITTI2012-test
%                     KITTI2015-train, KITTI2015-test
%                     Make3D-train, Make3D-test
%                     NYUDepthV2-train, NYUDepthV2-test
%                     ZED-01-standard, ZED-01-fill
%                     ZED-02-standard, ZED-02-fill
%                     ...            , ...
%                     ZED-15-standard, ZED-15-fill
trainDataset = 'HEIGHT-train';
testDataset = 'HEIGHT-test';

% TODO: testDataset is always being regenerated when changed, because cfg is
% different between the two datasets. This is expected because textons features
% should be different, but the other ones should stay the same.

% structure that contains the configuration of the image, patches, textons
cfg = defaultConfig(trainDataset);

% load or generate the training data set
[trainFeatures,trainDepths,trainFileNumbers] = loadData(trainDataset,cfg);

% optinally save the data set in WEKA format
% https://sourceforge.net/projects/weka/
saveAsWEKA = false;
if(saveAsWEKA)
   saveWEKA(cfg, trainDataset, trainFeatures, trainDepths); 
end

if strcmp(trainDataset,testDataset) % if only one set, use cross validation on the same set
    proportion = 0.7;
    shuffle = false; % train on the first part, test on the rest
    [trainFeatures,testFeatures,trainDepths,testDepths,...
    trainIndPerm,testIndPerm] = ...
        validationPartition(trainFeatures,trainDepths,...
        proportion,cfg.nPatches,shuffle);
    testFileNumbers = trainFileNumbers(testIndPerm);
    trainFileNumbers = trainFileNumbers(trainIndPerm);
else % load or generate the test data set
    [testFeatures,testDepths,testFileNumbers] = loadData(testDataset,cfg);
end

% filter out low confidence patches, to avoid learning wrong ground truths
confidenceThreshold = 0.0;
[trainFeatures,trainDepths,trainValidPatches] = filterByConfidence(...
    trainFeatures,trainDepths,trainFileNumbers,confidenceThreshold,cfg);

% normalize the training features to the [0 1] range
[trainFeatures,offset,scale] = normalizeFeatures(trainFeatures);
% normalize the test features using the same offset and scale
testFeatures = normalizeFeatures(testFeatures,offset,scale);

% add a constant column for bias
trainFeatures = [trainFeatures ones(size(trainFeatures,1),1)];
testFeatures = [testFeatures ones(size(testFeatures,1),1)];

trainModelFilename = [trainDataset '-model-train'];
if(exist(trainModelFilename, 'file'))
    % if the filename exists, do not train again:
    load(trainModelFilename);
else
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
    
    % save the results, so that retraining is not necessary
    save(trainModelFilename, 'model', 'trainPredictions', 'testPredictions', 'offset', 'scale');
end

% For checking if the predictions YHat (based on model) coincide with the testPredictions.
% YHat = predictCLS(testFeatures, model);

if(cfg.stepSize == 1)
    % rebuild the full depth maps for plotting, using ones as placeholders in
    % low-confidence patches
    % requires the step size to be 1
    trainAuxDepths = ones(cfg.nPatches*length(trainFileNumbers),1);
    trainAuxDepths(trainValidPatches,:) = trainPredictions;
    trainPredictions = trainAuxDepths;
    trainAuxDepths(trainValidPatches,:) = trainDepths;
    trainDepths = trainAuxDepths;
end

% perform post-processing and analysis on the predicted results
trainResultsFilename = [trainDataset '-results-train'];
processResults(trainPredictions,trainDepths,trainFileNumbers,trainDataset,...
    trainResultsFilename,cfg);
testResultsFilename = [testDataset '-results-test'];
processResults(testPredictions,testDepths,testFileNumbers,testDataset,...
    testResultsFilename,cfg);
