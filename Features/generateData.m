function [features,depths,labels,indFiles] = generateData(type,cfg)
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here

% load the file paths of both image and depth files
nFiles = 5; % for testing purposes
[imgFiles,depthFiles,indFiles] = dataFilePaths(type,nFiles,true);
nFiles = length(imgFiles);

% load the various filters to be applied to the images
[filters,channels] = filterBank();

% load the texton dictionary
textons = loadDictionary(cfg);

% generate the patch and texton rows and columns from the current cfg
p = patchConfiguration(cfg);

nInstances = nFiles*cfg.nPatches; % number of training/test instances
nFeaturesSax = 2*cfg.nScales*length(channels);
nFeaturesTxt = cfg.nTextons;
nFeatures = nFeaturesSax+nFeaturesTxt;
features = zeros(nInstances,nFeatures);
depths = zeros(nInstances,1);
labels = zeros(nInstances,1);
for i = 1:nFiles
    fprintf('File: %d/%d\n',i,nFiles);
%     read image from file, and extract the features
    imgRGB = imread(imgFiles{i});
    ind = (1:cfg.nPatches)+(i-1)*cfg.nPatches;
    features(ind,:) = extractFeatures(imgRGB,filters,channels,textons,p);
    
%     load and label the depth data into discrete classes
    load(depthFiles{i});
    depthsMat = Position3DGrid(:,:,4); %#ok<NODEF>
    ind = (1:cfg.nPatches)+(i-1)*cfg.nPatches;
    depths(ind) = depthsMat(:);
    labels(ind) = labelDepths(depths(ind),cfg.classEdges);
end
end