function J = costFunctionRegularization(lambdaVec,...
    trainFeatures,trainDepths,testFeatures,testDepths,modelType)
%COSTFUNCTIONREGULARIZATION Summary of this function goes here
%   Detailed explanation goes here

% optimization very slow, regularization parameter space very large
% try per-group instead of per-feature regularization parameters
lambda = diag(lambdaVec);
[~,~,predTestDepths] = regressionModel(...
    trainFeatures,trainDepths,testFeatures,modelType,lambda);
[~,~,J,~] = performanceMetrics(predTestDepths,testDepths,'test');
end