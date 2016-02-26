function [model,predicted,accuracy] = trainModel(features,labels,modelType)
%TRAINMODEL Summary of this function goes here
%   Detailed explanation goes here

disp('Starting training'); tic
if strcmp(modelType,'linear svm')
    addpath('./toolboxes/liblinear-2.1/matlab/');
    model = train(labels,sparse(features),'-s 2 -B 0 -c 1 -q');
end
if strcmp(modelType,'logistic ls')
    model = logisticLeastSquares(features,labels);
end
if strcmp(modelType,'calibrated ls')
    lambda = 1;
    [model,predicted,accuracy] = trainCLS(features,labels,lambda);
end
toc; disp('Model trained');
end