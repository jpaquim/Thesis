function predictedLabels = predictModel(features,labels,model,modelType)
%PREDICTMODEL Summary of this function goes here
%   Detailed explanation goes here

if strcmp(modelType,'linear svm')
    addpath('./toolboxes/liblinear-2.1/matlab/');
    % [predictedLabels,accuracy,decisionValues] = ...
    predictedLabels = predict(labels,sparse(features),model);
end
if strcmp(modelType,'calibrated ls')
    predictedLabels = predictCLS(model,features,labels);
end
end