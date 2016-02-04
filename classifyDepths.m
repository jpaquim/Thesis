function depthLabels = classifyDepths(depths)
%CLASSIFYDEPTHS Summary of this function goes here
%   Detailed explanation goes here

% discrete depth classes, how many? logspace?
nClasses = 10;
% ends of the intervals
edges = logspace(0,log10(81.01),nClasses+1);
leftEdges = edges(1:end-1);
rightEdges = edges(2:end);

nDepths = length(depths);
depthLabels = zeros(nDepths,1);
for i = 1:nDepths
    depthLabels(i) = find(depths(i)>=leftEdges & depths(i)<rightEdges);
end

end