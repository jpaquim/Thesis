function plotComparison(predictedLabels,indFiles,type,p)
%PLOTCOMPARISON Summary of this function goes here
%   Detailed explanation goes here

randInd = unidrnd(length(indFiles));
[imgFile,depthFile] = dataFilePaths(type,indFiles(randInd));
load(depthFile);
depths = Position3DGrid(:,:,4); %#ok<NODEF>
labels = labelDepths(depths);
ind = (1:p.nPatches)+(randInd-1)*p.nPatches;
preds = reshape(predictedLabels(ind),p.nRows,p.nCols);
figure;
subplot(2,2,1); imagesc(imread(imgFile)); title('Image');
subplot(2,2,2); imagesc(depths); title('Depths');
subplot(2,2,3); imagesc(labels); title('Depth classes');
subplot(2,2,4); imagesc(preds); title('Predicted depth classes');
end