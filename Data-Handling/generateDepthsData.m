function depths = generateDepthsData(depthFiles,cfg)
%GENERATEDEPTHSDATA Reads depth image files, returns a vector with all the data
%   depths = GENERATEDEPTHSDATA(depthFiles,cfg)
%   The input files are specifed as a cell vector of filenames, additional
%   required data is read from the cfg configuration structure.

nFiles = length(depthFiles);
nInstances = nFiles*cfg.nPatches; % number of training/test instances
depths = zeros(nInstances,1);
for i = 1:nFiles
    depthMap = imread(depthFiles{i});
    if size(depthMap,3) == 3
        depthMap = rgb2gray(depthMap);
    end
    depthMap = double(depthMap)/255;
    depthMap = cfg.minRange+(cfg.maxRange-cfg.minRange)*depthMap;
    if ~isempty(strfind(cfg.dataset,'ZED'))
        confidenceFilename = strrep(depthFiles{i},'depth','conf');
        confidenceMap = double(rgb2gray(imread(confidenceFilename)))/255;
        depthMap(confidenceMap < cfg.confidenceThreshold) = NaN;
    elseif ~isempty(strfind(cfg.dataset,'KITTI'))
%         how to detect low confidence regions in KITTI?
    end
    ind = (1:cfg.nPatches)+(i-1)*cfg.nPatches;
%     resize the depth map into the standard size
    depths(ind) = imresize(depthMap,cfg.mapSize);
end
end
