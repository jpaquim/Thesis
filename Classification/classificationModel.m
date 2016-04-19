function [model,predictedTrain,predictedTest] = classificationModel(...
    trainFeatures,trainLabels,testFeatures,testLabels,modelType)
%CLASSIFICATIONMODEL Summary of this function goes here
%   Detailed explanation goes here

disp('Started training'); tic
switch modelType
    case 'linear svm'
        addpath('./toolboxes/liblinear-2.1/matlab/');
        model = train(trainLabels,sparse(trainFeatures),'-s 2 -B 0 -c 1 -q');
        predictedTrain = predict(trainLabels,sparse(trainFeatures),model);
        predictedTest = predict(testLabels,sparse(testFeatures),model);
    case 'logistic ls'
        model = logisticLeastSquares(trainFeatures,trainLabels);
    case 'calibrated ls'
        lambda = 1;
        [model,predictedTrain,predictedTest] = ...
            classificationCLS(trainFeatures,trainLabels,lambda,...
            testFeatures,testLabels);
%     case 'decision tree'
%         model = fitctree(trainFeatures,trainLabels);
%         predictedTrain = predict(treeModel,trainFeatures);
%         predictedTest = predict(treeModel,testFeatures);
end
toc; disp('Model trained');
end