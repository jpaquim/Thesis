function [YHat,accuracy] = predictCLS(model,X,YCat)
%PREDICTCLS Summary of this function goes here
%   Detailed explanation goes here

n = size(X,1);
k = size(model.W,2);

YTilde = X*model.W;
maxIters = 50;
for t = 1:maxIters
%     calibrate the predictions
    G = [YTilde YTilde.^2/2 YTilde.^3/6 YTilde.^4/24];
    YHat = SimplexProj(G*model.WTilde);
%     fit the residual
    prevYTilde = YTilde;
    YTilde = YHat+X*model.W;
    normDiff = norm(prevYTilde-YTilde,'fro')/sqrt(n*k);
    if normDiff < 0.001
        fprintf('Converged at iteration %d\n',t);
        break
    end
end
[~,YHat] = max(YHat,[],2);
accuracy = sum(YHat == YCat)/n;
fprintf('Test accuracy: %f\n',accuracy);
end