% load the training data set
[featuresData,depthData] = loadTrainingData();

featuresData = normalizeFeatures(featuresData);

addpath('./toolboxes/liblinear-2.1/matlab/');
disp('Starting training'); tic
% train the linear SVM model
model = train(depthData,sparse(featuresData),'-s 2 -B 0.5 -c 10 -q');
toc; disp('Model trained');

% accuracy on the training set
[predictedDepths,accuracy,decisionValues] = ...
       predict(depthData,sparse(featuresData),model);

% addpath('./toolboxes/libsvm-3.21/matlab');
% disp('Starting training'); tic
% % train the RBF SVM model
% model = svmtrain(depthData,featuresData,'-s 0 -t 2 -C 0.015 -e 0.1');
% toc; disp('Model trained');
% 
% % accuracy on the training set
% [predictedDepths, accuracy, decisionValues] = ...
%        svmpredict(depthData,featuresData,model);

% Questions:
% linear SVM performance still very low, what could be the problem?
% introduce bias?
% depths are [305 55], images are [2272 1704], where to place the patches?
% misalignment between patches and depth data causing problems?
% how to handle boundaries in the super-patch scales?
% SVM with RBF kernel doesn't bring significant improvements.
