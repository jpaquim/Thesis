% load the training data set
[trainingFeatures,trainingLabels] = loadData('training');
% load the test data set
[testFeatures,testLabels] = loadData('test');

trainingFeatures = normalizeFeatures(trainingFeatures);

addpath('./toolboxes/liblinear-2.1/matlab/');
disp('Starting training'); tic
% train the linear SVM model
model = train(trainingLabels,sparse(trainingFeatures),'-s 2 -B 0 -c 1 -q');
toc; disp('Model trained');
% accuracy on the training set
[predictedLabels,accuracy,decisionValues] = ...
       predict(trainingLabels,sparse(trainingFeatures),model);

% addpath('./toolboxes/libsvm-3.21/matlab');
% disp('Starting training'); tic
% % train the RBF SVM model
% model = svmtrain(depthData,featuresData,'-s 0 -t 2 -C 0.015 -e 0.1');
% toc; disp('Model trained');
% % accuracy on the training set
% [predictedDepths, accuracy, decisionValues] = ...
%        svmpredict(depthData,featuresData,model);

% plot confusion matrix
% confMat = confusionmat(depthData,predictedDepths);
nClasses = 10;
% plotconfusion funtion needs data in binary form
labelsBin = convertToBinClasses(trainingLabels,nClasses);
predictedLabelsBin = convertToBinClasses(predictedLabels,nClasses);
plotconfusion(labelsBin,predictedLabelsBin);

% Questions:
% linear SVM performance still very low, what could be the problem?
% introduce bias?
% misalignment between patches and depth data causing problems?
% how to handle boundaries in the super-patch scales?
% SVM with RBF kernel doesn't bring significant improvements.
