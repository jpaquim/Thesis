function [edges,centers] = depthIntervals(depths,nClasses,classType)
%DEPTHINTERVALS Computes intervals for classification of continuous depths into
%discrete depth classes
%   Given the depth data to be discretized, the number of desired classes, and
%   the specified class type, the function returns the most adequate edges and
%   centers of the intervals corresponding to the discretization. Available
%   class types are 'lin', for linear spacing, 'log', for logarithmic spacing,
%   and 'opt', for optimal spacing based on the distribution of data, such that
%   the resulting histogram is nearly uniform over the classes.

% minimum and maximum depths in the data set
minDepth = min(depths);
maxDepth = max(depths);
switch classType
    case 'lin'
        edges = linspace(minDepth,maxDepth,nClasses+1);
        centers = mean([edges(1:end-1);edges(2:end)]);
    case 'log'
        edges = logspace(log10(minDepth),...
                         log10(maxDepth),nClasses+1);
        centers = exp(mean([log(edges(1:end-1));log(edges(2:end))]));
    case 'opt'
        depths = sort(depths);
        nInstances = size(depths,1);
        binSize = floor(nInstances/nClasses);
        binRemainder = mod(nInstances,nClasses);
        auxData = reshape(depths(1:end-binRemainder),binSize,nClasses);
        edges = [auxData(1,:) ceil(depths(end))];
        centers = mean(auxData);
    otherwise
        error('Unknown class type: %s',classType);
end

% allow classification of samples outside the training range
edges(1) = 0;
edges(end) = Inf;

end
