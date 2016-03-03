function [features,depths,labels,indFiles] = loadData(dataType,cfg)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

if strcmp(dataType,'training')
    fileName = 'trainingData.mat';
elseif strcmp(dataType,'test')
    fileName = 'testData.mat';
end
if exist(fileName,'file') % if the data file already exists
    fileVars = load(fileName,'cfg');
    if isequal(fileVars.cfg,cfg) % and if cfg is the same
        load(fileName); % load the data directly from it
        return;
    end
end
% if the data file doesn't exist, or cfg has changed, regenerate the data
[features,depths,labels,indFiles] = generateData(dataType,cfg);
save(fileName,'features','depths','labels','indFiles','cfg');
end