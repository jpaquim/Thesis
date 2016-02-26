function labels = labelDepths(depths,cfg)
%LABELDEPTHS Summary of this function goes here
%   Detailed explanation goes here

persistent optEdges;
switch cfg.classType
    case 'lin'
        edges = linspace(cfg.minDepth,cfg.maxDepth,cfg.nClasses+1);
    case 'log'
        edges = ...
          logspace(log10(cfg.minDepth),log10(cfg.maxDepth),cfg.nClasses+1);
    case 'opt'
        if isempty(optEdges)
            optEdges = optimalIntervals(cfg);
        end
        edges = optEdges;
    otherwise
        error('Unknown class type: %s',cfg.classType);
end
leftEdges = edges(1:end-1);
rightEdges = edges(2:end);
depthsAux = depths(:); % for vectorization purposes
[~,labelsAux] = max(bsxfun(@ge,depthsAux,leftEdges) & ...
                    bsxfun(@lt,depthsAux,rightEdges),[],2);
labels = reshape(labelsAux,size(depths));
end