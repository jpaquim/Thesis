function [normFeats,offset,scale] = normalizeFeatures(features,offset,scale)
%NORMALIZEFEATURES Summary of this function goes here
%   Detailed explanation goes here

if ~exist('offset','var')
%     Z-score scaling
%     offset = mean(features);
%     scale = std(features);
%     Min-Max scaling
    offset = min(features);
    scale = max(features)-min(features);
end
normFeats = bsxfun(@minus,features,offset);
normFeats = bsxfun(@rdivide,normFeats,scale);
end
