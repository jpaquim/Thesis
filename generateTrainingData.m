function [featuresData,depthData] = generateTrainingData()
%GENERATETRAININGDATA Summary of this function goes here
%   Detailed explanation goes here

% load the various filters to be applied to the images
[filters,channels] = buildFilters();

% load the training images, for feature extraction
folderName = './data/Train400Img/';
files = dir([folderName '*.jpg']);
% nFiles = length(files);
nFiles = 10; % for testing purposes

% a structure whose fields contain the configuration of the image and
% patches, including centroid locations.
p = patchConfiguration([2272 1704],[55 305],[5 5],3); % [21 21]);

nTrainingCases = nFiles*p.nPatches;
nFeatures = 2*p.nScales*length(channels);
featuresData = zeros(nTrainingCases,nFeatures);
for i = 1:nFiles
    fprintf('File: %d\n',i);
    filePath = [folderName files(i).name];
%     read image, and convert to YCbCr color space
    imgRGB = imread(filePath);
    img = double(rgb2ycbcr(imgRGB))/255; % divide by 255?
    ind = (1:p.nPatches)+(i-1)*p.nPatches;
    featuresData(ind,:) = extractFeatures(img,filters,channels,p);
end

% load the training depths, for depth quantization
folderName = './data/Train400Depth/';
files = dir([folderName '*.mat']);
% nFiles2 = length(files);
% if nFiles ~= nFiles2 % basic error checking
%     error('Unbalanced image and depth data');
% end

depthData = zeros(nTrainingCases,1);
for i = 1:nFiles
    filePath = [folderName files(i).name];
    load(filePath)
    depths = Position3DGrid(:,:,4);
    ind = (1:p.nPatches)+(i-1)*p.nPatches;
    depthData(ind) = classifyDepths(depths(:));
end

end