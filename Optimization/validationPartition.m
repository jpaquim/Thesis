function [trainFeatures,testFeatures,trainDepths,testDepths] = ...
    validationPartition(trainFeatures,trainDepths,proportion)
%VALIDATIONPARTITION Summary of this function goes here
%   Detailed explanation goes here

% split training data for validation using the holdout method
nInstances = size(trainFeatures,1);
indRand = randperm(nInstances);
indTest = indRand(1:round(proportion*nInstances));
indTrain = setdiff(indRand,indTest);
testFeatures = trainFeatures(indTest,:);
trainFeatures = trainFeatures(indTrain,:);
testDepths = trainDepths(indTest,:);
trainDepths = trainDepths(indTrain,:);
end