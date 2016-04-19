function labels = labelDepths(depths,edges)
%LABELDEPTHS Summary of this function goes here
%   Detailed explanation goes here

leftEdges = edges(1:end-1);
rightEdges = edges(2:end);
depthsAux = depths(:); % for vectorization purposes
[~,labelsAux] = max(bsxfun(@ge,depthsAux,leftEdges) & ...
                    bsxfun(@lt,depthsAux,rightEdges),[],2);
labels = reshape(labelsAux,size(depths));
end
