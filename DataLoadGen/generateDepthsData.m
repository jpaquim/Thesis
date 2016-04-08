function depths = generateDepthsData(depthFiles,cfg)
%GENERATEDEPTHSDATA Summary of this function goes here
%   Detailed explanation goes here

nFiles = length(depthFiles);
nInstances = nFiles*cfg.nPatches; % number of training/test instances
depths = zeros(nInstances,1);
for i = 1:nFiles
    load(depthFiles{i});
    ind = (1:cfg.nPatches)+(i-1)*cfg.nPatches;
    depths(ind) = depth;
end
end
