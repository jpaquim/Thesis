function [features,depths,labels,indFiles] = generateData(dataType,cfg)
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here

% load the file paths of both image and depth files
nFiles = 5; % for testing purposes
[imgFiles,depthFiles,indFiles] = dataFilePaths(dataType,nFiles,true);
nFiles = length(imgFiles);

% load the various filters to be applied to the images
[filters,channels] = filterBank(cfg);

% load the texton dictionary
textons = loadDictionary(cfg);

% precompute auxiliary variables needed afterwards, and update cfg
cfg = computeAuxVars(cfg);

nInstances = nFiles*cfg.nPatches; % number of training/test instances
nFeaturesFlt = 2*cfg.nScales*length(channels);
nFeaturesTxt = cfg.nTextons;
nFeaturesHOG = 9;
nFeaturesPos = 2;
nFeatures = nFeaturesFlt+nFeaturesTxt+nFeaturesHOG+nFeaturesPos;
features = zeros(nInstances,nFeatures);
depths = zeros(nInstances,1);
labels = zeros(nInstances,1);
for i = 1:nFiles
    fprintf('File: %d/%d\n',i,nFiles);
%     read image from file, and extract the features
    imgRGB = imread(imgFiles{i});
    ind = (1:cfg.nPatches)+(i-1)*cfg.nPatches;
    features(ind,:) = extractImgFeatures(imgRGB,filters,channels,textons,cfg);
    
%     load and label the depth data into discrete classes
    load(depthFiles{i});
    depthsMat = Position3DGrid(:,:,4); %#ok<NODEF>
    ind = (1:cfg.nPatches)+(i-1)*cfg.nPatches;
    depths(ind) = depthsMat(:);
    labels(ind) = labelDepths(depths(ind),cfg.classEdges);
end
end