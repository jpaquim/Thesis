function [features,depths,validPatches] = filterByConfidence(...
    features,depths,fileNumbers,threshold,cfg)
%FILTERBYCONFIDENCE Filters features and depths where the stereo estimate has
%low confidence
%   [features,depths,validPatches] = FILTERBYCONFIDENCE(...
%       features,depths,fileNumbers,threshold,cfg)

validPatches = zeros(size(depths));
if ~isempty(strfind(cfg.dataset,'ZED'))
%     confidence files have the same name as img files, but in the conf folder,
%     rather than img folder
    confFiles = strrep(dataFilePaths(cfg.dataset,fileNumbers),'img','conf');
    nFiles = length(confFiles);
    for i = 1:nFiles
        confidenceMap = imresize(...
            double(rgb2gray(imread(confFiles{i})))/255,cfg.mapSize);
        ind = (i-1)*cfg.nPatches+find(confidenceMap > threshold);
        validPatches(ind) = true;
    end
elseif ~isempty(strfind(cfg.dataset,'KITTI'))
%     how to detect low confidence regions in KITTI?
end
validPatches = find(validPatches);
features = features(validPatches,:);
depths = depths(validPatches);
end
