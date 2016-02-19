function [features,labels] = generateData(type)
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here

folderPrefix = './data/';
if strcmp(type,'training')
    imgFolder = 'Train400Img/';
    depthFolder = 'Train400Depth/';
elseif strcmp(type,'test')
    imgFolder = 'Test134Img/';
    depthFolder = 'Test134Depth/';
else
    error(['Invalid data type requested: ' type]);
end
folderName = [folderPrefix imgFolder];

% load the images, for feature extraction
files = dir([folderName '*.jpg']);
% nFiles = length(files);
nFiles = 10; % for testing purposes

% a structure whose fields contain the configuration of the image and
% patches, including centroid locations.
p = patchConfiguration([2272 1704],[55 305],[5 5],1); % [21 21]);

% load the various filters to be applied to the images
[filters,channels] = buildFilters();

nInstances = nFiles*p.nPatches; % number of training/test instances
nFeatures = 2*p.nScales*length(channels);
features = zeros(nInstances,nFeatures);
for i = 1:nFiles
    fprintf('File: %d\n',i);
    filePath = [folderName files(i).name];
%     read image from file
    imgRGB = imread(filePath);
    ind = (1:p.nPatches)+(i-1)*p.nPatches;
    features(ind,:) = extractFeatures(imgRGB,filters,channels,p);
end

% load the depth data, for depth quantization into discrete classes
folderName = [folderPrefix depthFolder];
files = dir([folderName '*.mat']);
% nFiles2 = length(files);
% if nFiles ~= nFiles2 % basic error checking
%     error('Unbalanced image and depth data');
% end

labels = zeros(nInstances,1);
for i = 1:nFiles
    filePath = [folderName files(i).name];
    load(filePath)
    depths = Position3DGrid(:,:,4);
    ind = (1:p.nPatches)+(i-1)*p.nPatches;
    labels(ind) = labelDepths(depths(:));
end

end