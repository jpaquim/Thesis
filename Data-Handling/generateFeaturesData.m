function features = generateFeaturesData(imgFiles,cfg)
%GENERATEFEATURESDATA Generates the features from the images
%   features = GENERATEFEATURESDATA(imgFiles,cfg)
%   The input files are specifed as a cell vector of filenames, additional
%   required data is read from the cfg configuration structure.

nFiles = length(imgFiles);
% load the various filters to be applied to the images
[filters,channels] = filterBank(cfg.useFilters);

textons = loadDictionary(cfg); % load the texton dictionary
% % precompute auxiliary variables needed afterwards, and update cfg
% cfg = computeAuxVars(cfg);

nRealPatches = length(1:cfg.stepSize:cfg.nPatches);
nInstances = nFiles*nRealPatches; % number of training/test instances
features = zeros(nInstances,cfg.nFeatures);
disp('Generating features');
for i = 1:nFiles
    fprintf('File: %d/%d\n',i,nFiles);
%     read image from file, resize it to the training data size, or fixed
    img = imresize(imread(imgFiles{i}),cfg.size);
    ind = (1:nRealPatches)+(i-1)*nRealPatches;
    features(ind,:) = extractImgFeatures(img,filters,channels,textons,cfg);
end
end
