function [model,YHat,accuracy] = trainCLS(X,YCat,lambda)
%CALIBRATEDLEASTSQUARES Summary of this function goes here
%   Detailed explanation goes here
%   Algorithm is essentially a slightly modified version of the code found
%   here: https://github.com/fest/secondorderdemos

Y = convertToBinClasses(YCat,10);
[n,d] = size(X);
k = size(Y,2);
% use the Cholesky decomposition for more efficient least squares
% regularize X'*X with the diagonal term, why the sqrt(n)?
cholLowerX = chol((X'*X)+lambda*sqrt(n)*eye(d),'lower');
% initialize W with the least squares estimate
W = cholLowerX'\(cholLowerX\(X'*Y));
YTilde = X*W;
maxIters = 50;
for t = 1:maxIters
%     calibrate the predictions
    G = [YTilde YTilde.^2/2 YTilde.^3/6 YTilde.^4/24];
    cholLowerG = chol(G'*G+sqrt(n)*eye(4*k),'lower');
    WTilde = cholLowerG'\(cholLowerG\(G'*Y));
    YHat = SimplexProj(G*WTilde);
%     fit the residual
    W = cholLowerX'\(cholLowerX\(X'*(Y-YHat)));
    prevYTilde = YTilde;
    YTilde = YHat+X*W;
    normDiff = norm(prevYTilde-YTilde,'fro')/sqrt(n*k);
    if normDiff < 0.001
        fprintf('Converged at iteration %d\n',t);
        break
    end
end
model.W = W;
model.WTilde = WTilde;
[~,YHat] = max(YHat,[],2);
accuracy = sum(YHat == YCat)/n;
fprintf('Training accuracy: %f\n',accuracy);
end