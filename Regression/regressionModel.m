function [model,predictedTrain,predictedTest] = regressionModel(...
    trainFeatures,trainDepths,testFeatures,testDepths,modelType)
%REGRESSIONMODEL Summary of this function goes here
%   Detailed explanation goes here

disp('Starting training'); tic
switch modelType
    case 'calibrated ls'
        lambda = 1;
        [model,predictedTrain,predictedTest] = ...
            regressionCLS(trainFeatures,trainDepths,lambda,...
            testFeatures);
%     case 'decision tree'
%         model = fitrtree(trainFeatures,trainDepths);
%         predictedTrain = predict(model,trainFeatures);
%         predictedTest = predict(model,testFeatures);
end
toc; disp('Model trained');
end