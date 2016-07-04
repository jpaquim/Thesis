function processResults(predictions,depths,fileNumbers,dataset,cfg)
%PROCESSRESULTS Summary of this function goes here
%   Detailed explanation goes here

switch cfg.outputType
    case 'regression'
        depthPredictions = predictions;
    case 'classification'
%         plot confusion matrix
%         figure; plotConfusionMatrix(labels,preds,cfg.nClasses);
%         convert labels to depths using the class centers
        depthPredictions = cfg.classCenters(predictions)';
end
% filter depths
depthPredictions = filterDepths(depthPredictions,cfg.mapSize,'median');
% saturate to the minimum camera range
depthPredictions = max(depthPredictions,cfg.minRange);
% performance metrics after filtering
performanceMetrics(depthPredictions,depths,dataset);
% plot example image, ground truth, labels, and prediction
plotComparison(depthPredictions,depths,fileNumbers,dataset,cfg);
end
