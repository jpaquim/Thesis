function [model,predictedTrain,predictedTest] = classificationModel(...
    trainFeatures,trainLabels,testFeatures,testLabels,modelType,lambda)
%CLASSIFICATIONMODEL Trains a supervised learning regression model
%   [model,predictedTrain,predictedTest] = CLASSIFICATIONMODEL(...
%       trainFeatures,trainLabels,testFeatures,testLabels,modelType,lambda)
%   The function expects training features and target values, the type of
%   model (currently 'linear svm', 'logistic ls', or 'calibrated ls') and an
%   optional regularization constant lambda. It trains the model and returns its
%   predictions on both the training and test sets.

disp('Started training'); tic
switch modelType
    case 'linear svm'
        addpath('./toolboxes/liblinear-2.1/matlab/');
        model = train(trainLabels,sparse(trainFeatures),'-s 2 -B 0 -c 1 -q');
        predictedTrain = predict(trainLabels,sparse(trainFeatures),model);
        predictedTest = predict(testLabels,sparse(testFeatures),model);
    case 'logistic ls'
        model = multiLogisticLS(trainFeatures,trainLabels);
    case 'calibrated ls'
        if ~exist('lambda','var')
            lambda = 1;
        end
        [model,predictedTrain,predictedTest] = ...
            classificationCLS(trainFeatures,trainLabels,lambda,...
            testFeatures,testLabels);
%     case 'decision tree'
%         model = fitctree(trainFeatures,trainLabels);
%         predictedTrain = predict(model,trainFeatures);
%         predictedTest = predict(model,testFeatures);
end
toc; disp('Model trained');
end
