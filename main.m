% add the paths of the various modules
addpath('./Features');
addpath('./Classification');
addpath('./Regression');
addpath('./Textons');
addpath('./Misc');

% structure that contains the configuration of the image, patches, textons
cfg = defaultConfig();

% load the training data set
[trainFeatures,trainDepths,trainLabels,indFilesTrain] = ...
    loadData('training',cfg);
% load the test data set
[testFeatures,testDepths,testLabels,indFilesTest] = ...
    loadData('test',cfg);

% normalize the training features to the [-1 1] range
[trainFeatures,offset,scale] = normalizeFeatures(trainFeatures);
% normalize the test features using the same offset and scale
testFeatures = normalizeFeatures(testFeatures,offset,scale);

% add a constant column for bias
trainFeatures = [trainFeatures ones(length(trainLabels),1)];
testFeatures = [testFeatures ones(length(testLabels),1)];

% return;

regression = true;
modelType = 'calibrated ls';

% train the supervised learning model
if regression
    [model,predTrainDepths,predTestDepths] = ...
        regressionModel(trainFeatures,trainDepths,...
                        testFeatures,testDepths,modelType);
else
    [model,predTrainLabels,predTestLabels] = ...
        classificationModel(trainFeatures,trainLabels,...
                            testFeatures,testLabels,modelType);
%     convert labels to depths using the class centers
    predTrainDepths = cfg.classCenters(predTrainLabels)';
    predTestDepths = cfg.classCenters(predTestLabels)';
%     plot confusion matrices
    plotConfusionMatrix(trainLabels,predTrainLabels,cfg.nClasses);
    figure; plotConfusionMatrix(testLabels,predTestLabels,cfg.nClasses);
end

% plot example image, ground truth, labels, and prediction
plotComparison(predTrainDepths,indFilesTrain,'training',cfg);
plotComparison(predTestDepths,indFilesTest,'test',cfg);

% performance metrics
performanceMetrics(trainDepths,predTrainDepths,'training');
performanceMetrics(testDepths,predTestDepths,'test');
