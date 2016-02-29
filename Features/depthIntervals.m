function [edges,centers] = depthIntervals(cfg)
%DEPTHINTERVALS Summary of this function goes here
%   Detailed explanation goes here
persistent optEdges;
switch cfg.classType
    case 'lin'
        edges = linspace(cfg.minDepth,cfg.maxDepth,cfg.nClasses+1);
        centers = mean([edges(1:end-1);edges(2:end)]);
    case 'log'
        edges = logspace(log10(cfg.minDepth),...
                         log10(cfg.maxDepth),cfg.nClasses+1);
        centers = 10.^(mean([log10(edges(1:end-1));
                             log10(edges(2:end))]));
    case 'opt'
        if isempty(optEdges)
            optEdges = optimalIntervals(cfg);
        end
        edges = optEdges;
        centers = mean([edges(1:end-1);edges(2:end)]);
    otherwise
        error('Unknown class type: %s',cfg.classType);
end
end