function [normFeats,offset,scale] = normalizeFeatures(features,offset,scale)
%NORMALIZEFEATURES Normalizes features to the [0, 1] range
%   [normFeats,offset,scale] = NORMALIZEFEATURES(features,offset,scale)
%   If offset and scale are given, it normalizes the features matrix
%   accordingly, subtracting the offset, and multiplying by the scale.
%   If offset and scale are not specified, it scales each column in the features
%   matrix such that its minimum is zero and its maximum is one. 

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
