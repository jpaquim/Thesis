function [features,labels] = loadData(type)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

if strcmp(type,'training')
    fileName = 'trainingData.mat';
elseif strcmp(type,'test')
    fileName = 'testData.mat';
end

if exist(fileName,'file')
%     if the file exists, load the data directly from it
    load(fileName);
else
%     if the file doesn't exist, regenerate the data file
    [features,labels] = generateData(type);
    save(fileName,'features','labels');
end
end