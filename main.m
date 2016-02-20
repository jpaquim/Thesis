addpath('./Features');
addpath('./Misc');
addpath('./Textons');

% load the training data set
[trainingFeatures,trainingLabels] = loadData('training');
% load the test data set
[testFeatures,testLabels] = loadData('test');

[trainingFeatures,offset,scale] = normalizeFeatures(trainingFeatures);
% normalize the test features using the same offset and scale
testFeatures = normalizeFeatures(testFeatures,offset,scale);

addpath('./toolboxes/liblinear-2.1/matlab/');
disp('Starting training'); tic
% train the linear SVM model
model = train(trainingLabels,sparse(trainingFeatures),'-s 2 -B 0 -c 1 -q');
toc; disp('Model trained');

% [predictedLabels,accuracy,decisionValues] = ...
% accuracy on the training set
predictedTraining = predict(trainingLabels,sparse(trainingFeatures),model);
% accuracy on the test set
predictedTest = predict(testLabels,sparse(testFeatures),model);

% plot confusion matrices for performance on training and test sets
plotConfusionMatrix(trainingLabels,predictedTraining);
figure; plotConfusionMatrix(testLabels,predictedTest);