function [trainFeatures,testFeatures,trainDepths,testDepths,...
    indPermTrain,indPermTest] = ...
    validationPartition(features,depths,proportion,nPatches,shuffle)
%VALIDATIONPARTITION Partitions a set for cross validation
%   Each sample in the set is assigned to either a training set or a test
%   set, with the specified proportion, using the holdout method. If
%   shuffle is true, samples are randomly assigned to each set. Otherwise,
%   they are assigned according to their indices, with lower indices going
%   in the training set, and higher indices going in the test set.

if ~exist('shuffle','var')
    shuffle = true;
end
if ~exist('nPatches','var')
    nPatches = 1; % shuffle individual patches
end
if ~exist('proportion','var')
    proportion = 0.7; % default value
end
nInstances = size(features,1);
nFiles = nInstances/nPatches;
if shuffle
    permTotal = randperm(nFiles);
else
    permTotal = 1:nFiles;
end
indPermTest = permTotal(1:round(proportion*nFiles));
indPermTrain = setdiff(permTotal,indPermTest);
indTrain = bsxfun(@plus,repmat((indPermTrain-1)*nPatches,nPatches,1),...
                        (1:nPatches)');
indTest = bsxfun(@plus,repmat((indPermTest-1)*nPatches,nPatches,1),...
                       (1:nPatches)');
testFeatures = features(indTest(:),:);
trainFeatures = features(indTrain(:),:);
testDepths = depths(indTest,:);
trainDepths = depths(indTrain,:);
end
