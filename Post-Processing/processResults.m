function processResults(preds,depths,labels,indFiles,...
                        dataType,outputType,cfg)
%PROCESSRESULTS Summary of this function goes here
%   Detailed explanation goes here

if strcmp(outputType,'regression')
    predDepths = preds;
else
%     plot confusion matrices
    figure; plotConfusionMatrix(labels,preds,cfg.nClasses);
%     convert labels to depths using the class centers
    predDepths = cfg.classCenters(preds)';
end
% plot example image, ground truth, labels, and prediction
plotComparison(predDepths,indFiles,dataType,cfg);
% performance metrics
performanceMetrics(predDepths,depths,dataType);
% filter depths
predDepthsFilt = filterDepths(predDepths,cfg.mapSize,'median');
% saturate to minimum and maximum
predDepthsFilt = min(max(predDepthsFilt,cfg.minDepth),cfg.maxDepth);
% plot example image, ground truth, labels, and prediction after filtering
plotComparison(predDepthsFilt,indFiles,dataType,cfg);
% performance metrics after filtering
performanceMetrics(predDepthsFilt,depths,dataType);
end