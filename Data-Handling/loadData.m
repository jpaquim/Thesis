function [features,depths,indFiles] = loadData(dataset,cfg)
%LOADDATA Loads depth and features from the dataset
%   [features,depths,indFiles] = LOADDATA(dataset,cfg)
%   Returns the dataset's depth and features data, regenerates it if it's not
%   available or if the configuration structure cfg has changed.

filename = [dataset '.mat'];
filename
exist(filename,'file')
if exist(filename,'file') % if the data file already exists
    fileVars = load(filename,'cfg');
    if isequal(fileVars.cfg,cfg) % and if cfg is the same
        load(filename); % load the data directly from it
        fprintf('Loaded the %s dataset\n',dataset);
        return;
    end
end
% if the data file doesn't exist, or cfg has changed, regenerate the data
nFiles = 50; % for testing purposes
% [imgFiles,depthFiles,indFiles] = dataFilePaths(dataset,nFiles,true);
[imgFiles,depthFiles,indFiles] = dataFilePaths(dataset,1:nFiles);
depths = generateDepthsData(depthFiles,cfg);
% TODO: in the training set, there's no need to compute features over areas
% where the disparity is invalid
features = generateFeaturesData(imgFiles,cfg);
save(filename,'features','depths','indFiles','cfg');
end
