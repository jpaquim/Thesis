function [features,depths,indFiles] = loadData(dataset,cfg)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

filename = [dataset '.mat'];
if exist(filename,'file') % if the data file already exists
    fileVars = load(filename,'cfg');
    if isequal(fileVars.cfg,cfg) % and if cfg is the same
        load(filename); % load the data directly from it
        fprintf('Loaded the %s dataset\n',dataset);
        return;
    end
end
% if the data file doesn't exist, or cfg has changed, regenerate the data
nFiles = 20; % for testing purposes
[imgFiles,depthFiles,indFiles] = dataFilePaths(dataset,nFiles,true);
fprintf('Generating features for the %s dataset\n',dataset);
features = generateFeaturesData(imgFiles,cfg);
depths = generateDepthsData(depthFiles,cfg);
save(filename,'features','depths','indFiles','cfg');
end
