function cfg = defaultConfig()
%DEFAULTCONFIG Summary of this function goes here
%   Detailed explanation goes here

% read image resolution from the first image in the training set
imgInfo = imfinfo(dataFilePaths('training',1));
% image height and width in pixels
cfg.size = [imgInfo.Height imgInfo.Width];
cfg.height = cfg.size(1);
cfg.width = cfg.size(2);

% number of rows and columns in the patch grid
cfg.gridSize = [55 305];
cfg.nRows = cfg.gridSize(1);
cfg.nCols = cfg.gridSize(2);
% total number of patches
cfg.nPatches = cfg.nRows*cfg.nCols;
% height and width of each patch in pixels
cfg.ptcSize = [5 5];
cfg.ptcHeight = cfg.ptcSize(1);
cfg.ptcWidth = cfg.ptcSize(1);
% number of size scales at which features are calculated
cfg.nScales = 3;

% minimum and maximum depths in the data set
cfg.depthLimits = [0.9 82];
cfg.minDepth = cfg.depthLimits(1);
cfg.maxDepth = cfg.depthLimits(2);
% number of classes used in the depth labeling
cfg.nClasses = 10;
% type of interval spacing, 'lin' for linear, 'log' for logarithmic,
cfg.classType = 'opt'; % 'opt' for optimal, uniform distribution of classes

% color or grayscale textons
cfg.txtColor = false;
% height and width of the textons in pixels
cfg.txtSize = [5 5];
cfg.txtHeight = cfg.txtSize(1);
cfg.txtWidth = cfg.txtSize(2);
% number of textons learned
cfg.nTextons = 30;
% number of texture samples extracted from each image
cfg.nTextures = 10000; % if nTextures = 'all', extract all possible samples
end