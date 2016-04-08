function plotComparison(predDepths,indFiles,dataType,cfg,ind)
%PLOTCOMPARISON Summary of this function goes here
%   Detailed explanation goes here

if ~exist('ind','var')
    ind = unidrnd(length(indFiles));
end
[imgFile,depthFile] = dataFilePaths(dataType,indFiles(ind));
load(depthFile);
labels = labelDepths(depth,cfg.classEdges);
predDepths = patchesToImages(predDepths,cfg.mapSize,ind);
figure;
subplot(2,2,1); image(imread(imgFile)); title('Image');
subplot(2,2,2); image(depth);          title('Depths');
subplot(2,2,3); imagesc(labels);        title('Depth classes');
subplot(2,2,4); image(predDepths);      title('Predicted depths');
end