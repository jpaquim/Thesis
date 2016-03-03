function [edges,centers] = optimalIntervals(cfg)
%OPTIMALINTERVALS Summary of this function goes here
%   Detailed explanation goes here

[~,depthFiles] = dataFilePaths('training');
nFiles = length(depthFiles);
nInstances = nFiles*cfg.nPatches;
depths = zeros(nInstances,1);
for i = 1:nFiles
    load(depthFiles{i});
    depthsAux = Position3DGrid(:,:,4); %#ok<NODEF>
    ind = (1:cfg.nPatches)+(i-1)*cfg.nPatches;
    depths(ind) = depthsAux(:);
end
depths = sort(depths);
binSize = floor(nInstances/cfg.nClasses);
binRemainder = mod(nInstances,cfg.nClasses);
auxData = reshape(depths(1:end-binRemainder),binSize,cfg.nClasses);
edges = [auxData(1,:) ceil(depths(end))];
centers = mean(auxData);
end