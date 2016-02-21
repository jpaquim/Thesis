function [features,labels,indFiles] = loadData(type,p,t)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

if strcmp(type,'training')
    fileName = 'trainingData.mat';
elseif strcmp(type,'test')
    fileName = 'testData.mat';
end
if exist(fileName,'file') % if the data file already exists
    fileVars = load(fileName,'p','t');
    if isequal(fileVars.p,p) && isequal(fileVars.t,t) % and if p and t are
        load(fileName); % as desired, load the data directly from it
        return;
    end
end
% if the file doesn't exist, or p/t has changed, regenerate the data file
[features,labels,indFiles] = generateData(type,p,t);
save(fileName,'features','labels','indFiles','p','t');
end