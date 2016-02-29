function [model,YHatTrain,YHatTest] = ...
    regressionCLS(XTrain,YTrain,lambda,XTest)
%REGRESSIONCLS Summary of this function goes here
%   Detailed explanation goes here
%   Algorithm is essentially a slightly modified version of the code found
%   here: https://github.com/fest/secondorderdemos

[n,d] = size(XTrain);
k = size(YTrain,2);
% use the Cholesky decomposition for more efficient least squares
% regularize X'*X with the diagonal term, why the sqrt(n)?
cholLowerX = chol((XTrain'*XTrain)+lambda*sqrt(n)*eye(d),'lower');
% initialize W with the least squares estimate
W = cholLowerX'\(cholLowerX\(XTrain'*YTrain));
YTildeTrain = XTrain*W;
YTildeTest = XTest*W;
maxIters = 50;
for t = 1:maxIters
%     calibrate the predictions
    G = [YTildeTrain YTildeTrain.^2/2 YTildeTrain.^3/6 YTildeTrain.^4/24];
    GTest = [YTildeTest YTildeTest.^2/2 YTildeTest.^3/6 YTildeTest.^4/24];
    cholLowerG = chol(G'*G+sqrt(n)*eye(4*k),'lower');
    WTilde = cholLowerG'\(cholLowerG\(G'*YTrain));
    YHatTrain = G*WTilde;
    YHatTest = GTest*WTilde;
%     fit the residual
    W = cholLowerX'\(cholLowerX\(XTrain'*(YTrain-YHatTrain)));
    prevYTilde = YTildeTrain;
    YTildeTrain = YHatTrain+XTrain*W;
    YTildeTest = YHatTest+XTest*W;
    normDiff = norm(prevYTilde-YTildeTrain,'fro')/sqrt(n*k);
    if normDiff < 0.001
        fprintf('Converged at iteration %d\n',t);
        break
    end
end
model.W = W;
model.WTilde = WTilde;
end