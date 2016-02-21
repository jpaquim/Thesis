function model = trainModel(features,labels,modelType)
%TRAINMODEL Summary of this function goes here
%   Detailed explanation goes here

if strcmp(modelType,'linear svm')
    addpath('./toolboxes/liblinear-2.1/matlab/');
    disp('Starting training'); tic
    % train the linear SVM model
    model = train(labels,sparse(features),'-s 2 -B 0 -c 1 -q');
    toc; disp('Model trained');
end
end