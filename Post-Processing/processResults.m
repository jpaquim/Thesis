function processResults(preds,depths,indFiles,dataset,cfg)
%PROCESSRESULTS Summary of this function goes here
%   Detailed explanation goes here

switch cfg.outputType
    case 'regression'
        predDepths = preds;
    case 'classification'
%         plot confusion matrix
%         figure; plotConfusionMatrix(labels,preds,cfg.nClasses);
%         convert labels to depths using the class centers
        predDepths = cfg.classCenters(preds)';
end
% filter depths
% predDepths = filterDepths(predDepths,cfg.mapSize,'median');
% saturate to zero
predDepths = max(predDepths,0);
% plot example image, ground truth, labels, and prediction
plotComparison(predDepths,depths,indFiles,dataset,cfg);
% performance metrics after filtering
performanceMetrics(predDepths,depths,dataset);
end
