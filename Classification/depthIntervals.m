function [edges,centers] = depthIntervals(cfg)
%DEPTHINTERVALS Summary of this function goes here
%   Detailed explanation goes here
persistent optEdges optCenters;
switch cfg.classType
    case 'lin'
        edges = linspace(cfg.minDepth,cfg.maxDepth,cfg.nClasses+1);
        centers = mean([edges(1:end-1);edges(2:end)]);
    case 'log'
        edges = logspace(log10(cfg.minDepth),...
                         log10(cfg.maxDepth),cfg.nClasses+1);
        centers = exp(mean([log(edges(1:end-1));log(edges(2:end))]));
    case 'opt'
        if isempty(optEdges)
            [optEdges,optCenters] = optimalIntervals(cfg);
        end
        edges = optEdges;
        centers = optCenters;
    otherwise
        error('Unknown class type: %s',cfg.classType);
end
end