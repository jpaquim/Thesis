function [featuresData,depthData] = loadTrainingData()
%LOADTRAININGDATA Summary of this function goes here
%   Detailed explanation goes here

if exist('trainingData.mat','file')
%     if the file exists, load the trainingData directly from it
    load trainingData;
else
%     if the file doesn't exist, regenerate the training data file
    [featuresData,depthData] = generateTrainingData();
    save trainingData featuresData depthData
end
end