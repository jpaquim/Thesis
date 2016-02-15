function [normFeats,offset,scale] = normalizeFeatures(features)
%NORMALIZEFEATURES Summary of this function goes here
%   Detailed explanation goes here

% Z-score scaling
% offset = mean(features);
% scale = std(features);

% Min-Max scaling
offset = min(features);
scale = max(features)-min(features);

normFeats = bsxfun(@minus,features,offset);
normFeats = bsxfun(@rdivide,normFeats,scale);

end