function plotComparison(predLabels,indFiles,type,cfg,ind)
%PLOTCOMPARISON Summary of this function goes here
%   Detailed explanation goes here

if ~exist('ind','var')
    ind = unidrnd(length(indFiles));
end

[imgFile,depthFile] = dataFilePaths(type,indFiles(ind));
load(depthFile);
depths = Position3DGrid(:,:,4); %#ok<NODEF>
labels = labelDepths(depths,cfg.classEdges);
ind = (1:cfg.nPatches)+(ind-1)*cfg.nPatches;
preds = reshape(predLabels(ind),cfg.nRows,cfg.nCols);
figure;
subplot(2,2,1); image(imread(imgFile)); title('Image');
subplot(2,2,2); image(depths); title('Depths');
subplot(2,2,3); imagesc(labels); title('Depth classes');
subplot(2,2,4); image(preds); title('Predicted depths/classes');
end