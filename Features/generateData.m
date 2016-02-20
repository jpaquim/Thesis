function [features,labels] = generateData(type)
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here

% generate the file paths of both image and depth files
[imgFiles,depthFiles] = dataFilePaths(type);
% nFiles = length(imgFiles);
% nFiles2 = length(depthFiles);
% if nFiles ~= nFiles2 % basic error checking
%     error('Unbalanced image and depth data');
% end
nFiles = 2; % for testing purposes

% a structure whose fields contain the configuration of the image and
% patches, including centroid locations.
imgInfo = imfinfo(imgFiles{1}); % read resolution from the first image
p = patchGridConfiguration([imgInfo.Height imgInfo.Width],...
                           [55 305],[11 11],1);

% load the various filters to be applied to the images
[filters,channels] = filterBank();

% load the texton dictionary
textons = loadDictionary('gray');

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