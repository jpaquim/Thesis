function cfg = defaultConfig(dataset)
%DEFAULTCONFIG Default configuration for computation of features, textons, etc.
%   The returned structure contains the definitions for various properties used
%   throughout the program, namely the dimensions of the dataset's images, the
%   range of the depth data, and parameters for the computed features

cfg.dataset = dataset;
fixedSize = true;

% read image resolution from the first image in the training set
[imgFile,depthFile] = dataFilePaths(cfg.dataset,1);
imgInfo = imfinfo(imgFile);
% image height and width in pixels
cfg.size = [imgInfo.Height imgInfo.Width];
if fixedSize
    cfg.size = round(800*[1 cfg.size(2)/cfg.size(1)]);
end
cfg.height = cfg.size(1);
cfg.width = cfg.size(2);

% camera range
if ~isempty(strfind(dataset,'Make3D'))
    range = [0.9200 81.9214];
elseif ~isempty(strfind(dataset, 'NYU'))
    range = [0.7133 9.9955];
elseif ~isempty(strfind(dataset, 'ZED'))
    range = [1 20];
    cfg.confidenceThreshold = 0.05;
else
    range = [1 100];
end
cfg.minRange = range(1);
cfg.maxRange = range(2);

% number of rows and columns in the depth map and patch grid
depthInfo = imfinfo(depthFile);
cfg.mapSize = [depthInfo.Height depthInfo.Width];
if fixedSize
    cfg.mapSize = round(55*[1 cfg.mapSize(2)/cfg.mapSize(1)]);
end
cfg.nRows = cfg.mapSize(1);
cfg.nCols = cfg.mapSize(2);
% total number of patches
cfg.nPatches = cfg.nRows*cfg.nCols;
% height and width of each patch in pixels
cfg.ptcSize = 15*[1 1];
cfg.ptcHeight = cfg.ptcSize(1);
cfg.ptcWidth = cfg.ptcSize(2);

% color or grayscale textons
cfg.txtColor = false;
% height and width of the textons in pixels
cfg.txtSize = 5*[1 1];
cfg.txtHeight = cfg.txtSize(1);
cfg.txtWidth = cfg.txtSize(2);
% number of textons learned
cfg.nTextons = 30;
% number of texture samples extracted from each image
cfg.nTextures = 100000; % if nTextures = 'all', extract all possible samples

cfg.nHOGBins = 9;
cfg.nRadonAngles = 15;
cfg.nStructBins = 15;

% possible feature types: Coordinates, FiltersL1, FiltersL2, FiltersL4,
% HOG, Textons, Radon, StructTensor
possibleFeatures = {'Coordinates','Filters','HOG','Textons','Radon',...
                    'StructTensor'};
cfg.featureTypes = {'Filters','Textons','Radon'};
% boolean vector indicating features used
cfg.useFeatures = ismember(possibleFeatures,cfg.featureTypes);

% possible filter types: LawsMasks, CbCrLocalAverage, OrientedEdgeDetectors
possibleFilters = {'LawsMasks','CbCrLocalAverage','OrientedEdgeDetectors'};
cfg.filterTypes = {'LawsMasks','CbCrLocalAverage','OrientedEdgeDetectors'};
% cfg.filterTypes = {'LawsMasks','OrientedEdgeDetectors'}; % for B&W images
% boolean vector indicating filters used
cfg.useFilters = ismember(possibleFilters,cfg.filterTypes);
% dimensions of each filter group, in the above order
filterDims = [9;2;6];
% total number of filters
cfg.nFilters = dot(filterDims,cfg.useFilters);

% number of size scales at which filter features are calculated
cfg.nScales = 2;
% dimensions of each feature group, in the above order
featureDims = [2;2*cfg.nFilters*cfg.nScales;cfg.nHOGBins;cfg.nTextons;...
               2*cfg.nRadonAngles;cfg.nStructBins];
% total number of features
cfg.nFeatures = dot(featureDims,cfg.useFeatures);

end
