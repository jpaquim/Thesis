function [features,depths,labels,indFiles] = loadData(dataType,cfg)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

if strncmp(dataType,'train',5)
    fileName = 'trainData.mat';
elseif strncmp(dataType,'test',4)
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
if strcmp(dataType,'training') % for testing purposes
    nFiles = 100; % all
else
    nFiles = 20; % all
end
[imgFiles,depthFiles,indFiles] = dataFilePaths(dataType,nFiles,true);
features = generateFeaturesData(imgFiles,cfg);
depths = generateDepthsData(depthFiles,cfg);
% label the depth data into discrete classes
labels = labelDepths(depths,cfg.classEdges);
save(fileName,'features','depths','labels','indFiles','cfg');
end
