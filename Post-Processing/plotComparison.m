function plotComparison(predDepths,depths,indFiles,dataset,cfg,ind)
%PLOTCOMPARISON Summary of this function goes here
%   Detailed explanation goes here

if ~exist('ind','var')
    ind = unidrnd(length(indFiles));
end
imgFile = dataFilePaths(dataset,indFiles(ind));
depths = patchesToImages(depths,cfg.mapSize,ind);
predDepths = patchesToImages(predDepths,cfg.mapSize,ind);
scrsz = get(groot,'ScreenSize');
figure('Position',[scrsz(3)/8 scrsz(4)/2 scrsz(3)*3/4 scrsz(4)/2]);
switch cfg.outputType
    case 'regression'
        cLim = [min(depths(:)) max(depths(:))];
        subplot(1,3,1); image(imread(imgFile));
        title('Image');
        subplot(1,3,2); imagesc(depths,cLim);
        title('Depths');
        subplot(1,3,3); imagesc(predDepths,cLim);
        title('Predicted depths');
    case 'classification'
        predLabels = labelDepths(predDepths,cfg.classEdges);
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
