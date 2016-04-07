function cfg = updateConfig(cfg,parameterVec)
%UPDATECONFIG Summary of this function goes here
%   Detailed explanation goes here

% height and width of each patch in pixels
% should be odd
cfg.ptcSize = [2*parameterVec(1)+1 2*parameterVec(1)+1]; % square patches
cfg.ptcHeight = cfg.ptcSize(1);
cfg.ptcWidth = cfg.ptcSize(2);

% height and width of the textons in pixels
% should be odd
cfg.txtSize = [2*parameterVec(2)+1 2*parameterVec(2)+1]; % square textons
cfg.txtHeight = cfg.txtSize(1);
cfg.txtWidth = cfg.txtSize(2);
% number of textons learned
cfg.nTextons = parameterVec(3);

cfg.nHOGBins = parameterVec(4);
cfg.nRadonAngles = parameterVec(5);
cfg.nStructBins = parameterVec(6);

% number of size scales at which filter features are calculated
cfg.nScales = parameterVec(7);
% dimensions of each feature group, in the above order
featureDims = [2;2*cfg.nFilters*cfg.nScales;cfg.nHOGBins;cfg.nTextons;...
               2*cfg.nRadonAngles;cfg.nStructBins];
% total number of features
cfg.nFeatures = dot(featureDims,cfg.useFeatures);

% number of classes used in the depth labeling
cfg.nClasses = parameterVec(8);
% type of interval spacing, 'lin' for linear, 'log' for logarithmic,
cfg.classType = 'opt'; % 'opt' for optimal, uniform histogram over classes
[cfg.classEdges,cfg.classCenters] = depthIntervals(cfg);

end