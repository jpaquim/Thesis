% load the training data set
[featuresData,depthData] = loadTrainingData();

% featuresData = normalizeFeatures(featuresData);

addpath('./toolboxes/liblinear-2.1/matlab/');
disp('Starting training'); tic
% train the SVM model
model = train(depthData,sparse(featuresData),'-s 2');
toc; disp('Model trained');

% accuracy on the training set
[predictedDepths, accuracy, decisionValues] = ...
       predict(depthData,sparse(featuresData),model);
