function [features,labels,indFiles] = generateData(type,p,t)
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here

% generate the file paths of both image and depth files
nFiles = 50; % for testing purposes
[imgFiles,depthFiles,indFiles] = dataFilePaths(type,nFiles,true);
% nFiles = length(imgFiles);

% load the various filters to be applied to the images
[filters,channels] = filterBank();

% load the texton dictionary
textons = loadDictionary(t);

nInstances = nFiles*p.nPatches; % number of training/test instances
nFeaturesSax = 2*p.nScales*length(channels);
nFeaturesTxt = 30;
nFeatures = nFeaturesSax+nFeaturesTxt;
features = zeros(nInstances,nFeatures);
labels = zeros(nInstances,1);
for i = 1:nFiles
    fprintf('File: %d\n',i);
%     read image from file, and extract the features
    imgRGB = imread(imgFiles{i});
    ind = (1:p.nPatches)+(i-1)*p.nPatches;
    features(ind,:) = extractFeatures(imgRGB,filters,channels,textons,p);
    
%     load and label the depth data into discrete classes
    load(depthFiles{i});
    depths = Position3DGrid(:,:,4); %#ok<NODEF>
    ind = (1:p.nPatches)+(i-1)*p.nPatches;
    labels(ind) = labelDepths(depths(:));
end
end