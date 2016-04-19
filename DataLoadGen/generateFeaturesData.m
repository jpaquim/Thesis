function features = generateFeaturesData(imgFiles,cfg)
%GENERATEFEATURESDATA Summary of this function goes here
%   Detailed explanation goes here

nFiles = length(imgFiles);
% load the various filters to be applied to the images
[filters,channels] = filterBank(cfg.useFilters);

textons = loadDictionary(cfg); % load the texton dictionary
% precompute auxiliary variables needed afterwards, and update cfg
cfg = computeAuxVars(cfg);

nInstances = nFiles*cfg.nPatches; % number of training/test instances
features = zeros(nInstances,cfg.nFeatures);
for i = 1:nFiles
    fprintf('File: %d/%d\n',i,nFiles);
%     read image from file and resize it to the training data size
    img = imresize(imread(imgFiles{i}),cfg.size);
    ind = (1:cfg.nPatches)+(i-1)*cfg.nPatches;
    features(ind,:) = extractImgFeatures(img,filters,channels,textons,cfg);
end
end