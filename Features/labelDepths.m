function labels = labelDepths(depths)
%LABELDEPTHS Summary of this function goes here
%   Detailed explanation goes here

% label continuous depth values into discrete classes
nClasses = 10; % TODO: discover optimal number of classes

% ends of the intervals
edges = logspace(log10(0.9),log10(82),nClasses+1);
% try 1/depth
leftEdges = edges(1:end-1);
rightEdges = edges(2:end);

nDepths = length(depths);
labels = zeros(nDepths,1);
for i = 1:nDepths
    labels(i) = find(depths(i)>=leftEdges & depths(i)<rightEdges);
end
end