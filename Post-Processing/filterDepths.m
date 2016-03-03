function [ output_args ] = filterDepths(depths,gridSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

depthStack = patchesToImages(depths,gridSize);
for i = 1:length(indFilesTrain)
    predTrainDepthsFilt(:,:,i) = medfilt2(predTrainStack(:,:,i));
    predTestDepthsFilt(:,:,i) = medfilt2(depthStack(:,:,i));
end
predTrainDepthsFilt = predTrainDepthsFilt(:);
predTestDepthsFilt = predTestDepthsFilt(:);
end