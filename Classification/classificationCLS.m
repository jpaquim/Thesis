function [model,YHatTrain,YHatTest] = ...
    classificationCLS(XTrain,YTrainCat,lambda,XTest,YTestCat)
%CLASSIFICATIONCLS Summary of this function goes here
%   Detailed explanation goes here
%   Algorithm is essentially a slightly modified version of the code found
%   here: https://github.com/fest/secondorderdemos

YTrain = convertToBinClasses(YTrainCat,10);
[n,d] = size(XTrain);
k = size(YTrain,2);
if isscalar(lambda)
    regularizer = sqrt(n)*lambda*eye(d);
else
    regularizer = sqrt(n)*lambda;
end
% use the Cholesky decomposition for efficient least squares, regularized
cholLowerX = chol(XTrain'*XTrain+regularizer,'lower');
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
    YHatTrain = SimplexProj(G*WTilde);
    YHatTest = SimplexProj(GTest*WTilde);
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
[~,YHatTrain] = max(YHatTrain,[],2);
[~,YHatTest] = max(YHatTest,[],2);
trainAccuracy = sum(YHatTrain == YTrainCat)/n;
testAccuracy = sum(YHatTest == YTestCat)/n;
fprintf('Training accuracy: %f\nTest accuracy: %f\n',...
        trainAccuracy,testAccuracy);
end