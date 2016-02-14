function depthLabels = classifyDepths(depths)
%CLASSIFYDEPTHS Summary of this function goes here
%   Detailed explanation goes here

% classify continuous depth values into discrete classes
nClasses = 10; % TODO: discover optimal number of classes

% ends of the intervals
edges = logspace(0,log10(82),nClasses+1);
leftEdges = edges(1:end-1);
rightEdges = edges(2:end);

nDepths = length(depths);
depthLabels = zeros(nDepths,1);
for i = 1:nDepths
    depthLabels(i) = find(depths(i)>=leftEdges & depths(i)<rightEdges);
end
end