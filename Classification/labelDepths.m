function labels = labelDepths(depths,edges)
%LABELDEPTHS Labels depth data according to the discrete intervals
%   For each element of depths, returns the numeric label of its enclosing
%   interval, where the intervals are specified by their edges in the edges
%   vector.

leftEdges = edges(1:end-1);
rightEdges = edges(2:end);
depthsAux = depths(:); % for vectorization purposes
[~,labelsAux] = max(bsxfun(@ge,depthsAux,leftEdges) & ...
                    bsxfun(@lt,depthsAux,rightEdges),[],2);
labels = reshape(labelsAux,size(depths));
end
