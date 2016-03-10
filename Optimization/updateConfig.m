function cfg = updateConfig(cfg,parameterVec)
%UPDATECONFIG Summary of this function goes here
%   Detailed explanation goes here

% height and width of each patch in pixels
cfg.ptcSize = [parameterVec(1) parameterVec(2)];
cfg.ptcHeight = cfg.ptcSize(1);
cfg.ptcWidth = cfg.ptcSize(2);

% height and width of the textons in pixels
cfg.txtSize = [parameterVec(3) parameterVec(4)];
cfg.txtHeight = cfg.txtSize(1);
cfg.txtWidth = cfg.txtSize(2);
% number of textons learned
cfg.nTextons = parameterVec(5);

cfg.nHOGBins = parameterVec(6);
cfg.nRadonAngles = parameterVec(7);
cfg.nStructBins = parameterVec(8);

% number of size scales at which filter features are calculated
cfg.nScales = parameterVec(9);
% dimensions of each feature group, in the above order
featureDims = [2;2*cfg.nFilters*cfg.nScales;cfg.nHOGBins;cfg.nTextons;...
               2*cfg.nRadonAngles;cfg.nStructBins];
% total number of features
cfg.nFeatures = dot(featureDims,cfg.useFeatures);

% number of classes used in the depth labeling
cfg.nClasses = parameterVec(10);
% type of interval spacing, 'lin' for linear, 'log' for logarithmic,
cfg.classType = 'opt'; % 'opt' for optimal, uniform histogram over classes
[cfg.classEdges,cfg.classCenters] = depthIntervals(cfg);

end