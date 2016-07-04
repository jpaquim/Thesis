function [model,predTrainDepths,predTestDepths] = regressionModel(...
    trainFeatures,trainDepths,testFeatures,modelType,lambda)
%REGRESSIONMODEL Trains a supervised learning regression model
%   [model,predTrainDepths,predTestDepths] =
%       REGRESSIONMODEL(trainFeatures,trainDepths,testFeatures,modelType,lambda)
%   The function expects training features and target values, the type of
%   model (currently only 'calibrated ls') and an optional regularization
%   constant lambda. It trains the model and returns its predictions on
%   both the training and test sets.

trainDepths = log(trainDepths); % regression in logspace
disp('Started training'); tic
switch modelType
    case 'calibrated ls'
        if ~exist('lambda','var')
            lambda = 1;
        end
        [model,predTrainDepths,predTestDepths] = ...
            regressionCLS(trainFeatures,trainDepths,lambda,testFeatures);
end
toc; disp('Model trained');
predTrainDepths = real(predTrainDepths); % TODO: correct bug, remove these
predTestDepths = real(predTestDepths);
predTrainDepths = exp(predTrainDepths); % convert back to linear space
predTestDepths = exp(predTestDepths);
end
