function [features,labels,indFiles] = loadData(type,cfg)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

if strcmp(type,'training')
    fileName = 'trainingData.mat';
elseif strcmp(type,'test')
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
[features,labels,indFiles] = generateData(type,cfg);
save(fileName,'features','labels','indFiles','cfg');
end