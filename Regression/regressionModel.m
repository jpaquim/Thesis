function [model,predTrainDepths,predTestDepths] = regressionModel(...
    trainFeatures,trainDepths,testFeatures,modelType)
%REGRESSIONMODEL Summary of this function goes here
%   Detailed explanation goes here

trainDepths = log(trainDepths); % regression in logspace
disp('Starting training'); tic
switch modelType
    case 'calibrated ls'
        lambda = 50; % TODO: implement per-feature regularization
        [model,predTrainDepths,predTestDepths] = ...
            regressionCLS(trainFeatures,trainDepths,lambda,...
            testFeatures);
%     case 'decision tree'
%         model = fitrtree(trainFeatures,trainDepths);
%         predictedTrain = predict(model,trainFeatures);
%         predictedTest = predict(model,testFeatures);
end
toc; disp('Model trained');
predTrainDepths = exp(predTrainDepths); % convert back to linear space
predTestDepths = exp(predTestDepths);
end