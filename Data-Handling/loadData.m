function [features,depths,fileNumbers] = loadData(dataset,cfg)
%LOADDATA Loads depth and features from the dataset
%   [features,depths,fileNumbers] = LOADDATA(dataset,cfg)
%   Returns the dataset's depth and features data, regenerates it if it's not
%   available or if the configuration structure cfg has changed.

% when testing the program itself, recheck for changes in the features
% configuration, and use a smaller number of files
testing = false;
filename = [dataset '.mat'];
if exist(filename,'file') % if the data file already exists
    fileVars = load(filename,'cfg');
    if ~testing || isequal(fileVars.cfg,cfg) % and if cfg is the same
        load(filename); % load the data directly from it
        fprintf('Loaded the %s dataset\n',dataset);
        return;
    end
end
% if the data file doesn't exist, or cfg has changed, regenerate the data

shuffle = false; % shuffle the order of files
if testing
    nFiles = 50;
    if ~shuffle
        nFiles = 1:nFiles; % if not shuffling, use the first nFiles
    end
else
    nFiles = 'all';
end
[imgFiles,depthFiles,fileNumbers] = dataFilePaths(dataset,nFiles,shuffle);

% precompute auxiliary variables needed afterwards, and update cfg
% we now do it here to get the depths at the right positions
cfg = computeAuxVars(cfg);

depths = generateDepthsData(depthFiles,cfg);
features = generateFeaturesData(imgFiles,cfg);
save(filename,'features','depths','fileNumbers','cfg','-v7.3');
% the features variable can easily exceed 2GB, so the v7.3 switch must be used
end
