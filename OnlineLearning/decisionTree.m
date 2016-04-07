% function [ output_args ] = decisionTree(  )
%DECISIONTREE Summary of this function goes here
%   Detailed explanation goes here

load ionosphere

% tc = fitctree(X,Y);
% view(tc,'Mode','graph')

[nInstances,nFeatures] = size(X);
labels = unique(Y);
nLabels = length(labels);
Y2 = zeros(nInstances,nLabels);
for i = 1:nLabels
    Y2(:,i) = strcmp(Y,labels(i));
end

XSplit = sort(X);
XSplit2 = (X(1:end-1,:)+X(2:end,:))/2;

f = sum(Y2)/nInstances;
splitEntropy = zeros(nInstances,nFeatures);
minSplitEntropy = 1;
for ft = 1:nFeatures
    for i = 1:nInstances-1
        lSplit = find(X(:,ft) < XSplit2(i,ft));
        rSplit = find(X(:,ft) >= XSplit2(i,ft));
        nLeft = length(lSplit);
        nRight = length(rSplit);
        lProp = nLeft/nInstances;
        rProp = nRight/nInstances;
        lF = sum(Y2(lSplit,:))/nLeft;
        rF = sum(Y2(rSplit,:))/nRight;
        lEntropy = -sum(lF.*log2(lF));
        rEntropy = -sum(rF.*log2(rF));
%         lGiniImpurity = 1-sum(lF.^2);
%         rGiniImpurity = 1-sum(rF.^2);
        splitEntropy = lProp*lEntropy+rProp*rEntropy;
%         splitGiniImpurity = lProp*lGiniImpurity+rProp*rGiniImpurity;
        if splitEntropy < minSplitEntropy
            minSplitEntropy = splitEntropy;
            splitFeature = ft;
            splitThreshold = XSplit2(i,ft);
        end
    end
end

% end