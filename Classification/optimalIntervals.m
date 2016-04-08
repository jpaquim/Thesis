function [edges,centers] = optimalIntervals(cfg)
%OPTIMALINTERVALS Summary of this function goes here
%   Detailed explanation goes here

[~,depthFiles] = dataFilePaths(['train' cfg.dataSet]);
depths = sort(generateDepthsData(depthFiles,cfg));
nInstances = size(depths,1);
binSize = floor(nInstances/cfg.nClasses);
binRemainder = mod(nInstances,cfg.nClasses);
auxData = reshape(depths(1:end-binRemainder),binSize,cfg.nClasses);
edges = [auxData(1,:) ceil(depths(end))];
centers = mean(auxData);
end