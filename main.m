% add the paths of the various modules
addpath('./Features');
addpath('./Learning');
addpath('./Textons');
addpath('./Misc');

% structure that contains the configuration of the image, patches, textons
cfg = defaultConfig();

% load the training data set
[trainFeatures,trainLabels,indFilesTrain] = loadData('training',cfg);
% load the test data set
[testFeatures,testLabels,indFilesTest] = loadData('test',cfg);

% normalize the training features to the [-1 1] range
[trainFeatures,offset,scale] = normalizeFeatures(trainFeatures);
% normalize the test features using the same offset and scale
testFeatures = normalizeFeatures(testFeatures,offset,scale);

% return;
modelType = 'calibrated ls';
% train the supervised learning model
model = trainModel(trainFeatures,trainLabels,modelType);

% predict and evaluate accuracy on the training set
predictedTrain = predictModel(trainFeatures,trainLabels,model,modelType);
% predict and evaluate accuracy on the test set
predictedTest = predictModel(testFeatures,testLabels,model,modelType);

% plot confusion matrices for performance on training and test sets
plotConfusionMatrix(trainLabels,predictedTrain,cfg.nClasses);
figure; plotConfusionMatrix(testLabels,predictedTest,cfg.nClasses);

% plot example image, ground truth, labels, and prediction
plotComparison(predictedTrain,indFilesTrain,'training',cfg);
plotComparison(predictedTest,indFilesTest,'test',cfg);
