function [model,predTrainDepths,predTestDepths] = regressionModel(...
    trainFeatures,trainDepths,testFeatures,testDepths,modelType)
%REGRESSIONMODEL Summary of this function goes here
%   Detailed explanation goes here

trainDepths = log(trainDepths);
% testDepths = log(testDepths);

disp('Starting training'); tic
switch modelType
    case 'calibrated ls'
        lambda = 10;
        [model,predTrainDepths,predTestDepths] = ...
            regressionCLS(trainFeatures,trainDepths,lambda,...
            testFeatures);
%     case 'decision tree'
%         model = fitrtree(trainFeatures,trainDepths);
%         predictedTrain = predict(model,trainFeatures);
%         predictedTest = predict(model,testFeatures);
end
toc; disp('Model trained');

predTrainDepths = exp(predTrainDepths);
predTestDepths = exp(predTestDepths);

end