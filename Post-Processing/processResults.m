function processResults(predictions,depths,fileNumbers,dataset,filename,cfg)
%PROCESSRESULTS Plots comparisons and reports error metrics of the learning
%outcome
%   PROCESSRESULTS(predictions,depths,fileNumbers,dataset,filename,cfg)
%   Saves results to the file indicated by filename.

switch cfg.outputType
    case 'regression'
        depthPredictions = predictions;
    case 'classification'
%         plot confusion matrix
%         figure; plotConfusionMatrix(labels,preds,cfg.nClasses);
%         convert labels to depths using the class centers
        depthPredictions = cfg.classCenters(predictions)';
end

if(cfg.stepSize == 1)
    % filter depths in image space - needs the step size to be 1:
    depthPredictions = filterDepths(depthPredictions,cfg.mapSize,'median');
end
% saturate to the minimum camera range
depthPredictions = max(depthPredictions,cfg.minRange);
% performance metrics after filtering
[logError,relativeAbsoluteError,relativeSquareError,...
    rmsLinearError,rmsLogError,scaleInvariantError] = ...
    performanceMetrics(depthPredictions,depths,dataset);
save(filename,'depthPredictions','logError','relativeAbsoluteError',...
    'relativeSquareError','rmsLinearError','rmsLogError','scaleInvariantError');
if(cfg.stepSize == 1)
    % plot example image, ground truth, labels, and prediction
    plotComparison(depthPredictions,depths,fileNumbers,dataset,cfg);
end
end
