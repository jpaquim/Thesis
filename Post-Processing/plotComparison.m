function plotComparison(depthPredictions,depths,fileNumbers,dataset,cfg,...
    fileIndex)
%PLOTCOMPARISON Summary of this function goes here
%   Detailed explanation goes here

if ~exist('ind','var')
    fileIndex = unidrnd(length(fileNumbers));
end
imgFile = dataFilePaths(dataset,fileNumbers(fileIndex));
depths = patchesToImages(depths,cfg.mapSize,fileIndex);
depthPredictions = patchesToImages(depthPredictions,cfg.mapSize,fileIndex);
scrsz = get(groot,'ScreenSize');
figure('Position',[scrsz(3)/8 scrsz(4)/2 scrsz(3)*3/4 scrsz(4)/2]);
switch cfg.outputType
    case 'regression'
        cLim = [min(depths(:)) max(depths(:))];
        subplot(1,3,1); image(imread(imgFile));
        title('Image');
        subplot(1,3,2); imagesc(depths,cLim);
        title('Depths');
        subplot(1,3,3); imagesc(depthPredictions,cLim);
        title('Predicted depths');
    case 'classification'
        predLabels = labelDepths(depthPredictions,cfg.classEdges);
        labels = labelDepths(depths,cfg.classEdges);
        cLim = [min(labels(:)) max(labels(:))];
        subplot(1,3,1); image(imread(imgFile));
        title('Image');
        subplot(1,3,2); imagesc(labels,cLim);
        title('Depth classes');
        subplot(1,3,3); imagesc(predLabels,cLim);
        title('Predicted depth classes');
end
end
