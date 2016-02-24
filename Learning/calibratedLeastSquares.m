function [model,trainAccuracy] = calibratedLeastSquares(X,YCat,lambda,XTest,YTestCat)
%CALIBRATEDLEASTSQUARES Summary of this function goes here
%   Detailed explanation goes here

Y = convertToBinClasses(YCat,10);
[n,d] = size(X);
k = size(Y,2);
% use the Cholesky decomposition for more efficient least squares
% regularize X'*X with the diagonal term, why the sqrt(n)?
cholLowerX = chol((X'*X)+lambda*sqrt(n)*eye(d),'lower');
% initialize W with least squares estimate
W = cholLowerX'\(cholLowerX\(X'*Y));
YTilde = X*W;
YTildeTest = XTest*W;
maxIters = 10;
for t = 1:maxIters
%     calibrate the predictions
    G = [YTilde YTilde.^2/2 YTilde.^3/6 YTilde.^4/24];
    GTest = [YTildeTest YTildeTest.^2/2 YTildeTest.^3/6 YTildeTest.^4/24];
    cholLowerG = chol(G'*G+sqrt(n)*eye(4*k),'lower');
    WTilde = cholLowerG'\(cholLowerG\(G'*Y));
%     class(G*WTilde)
    YHat = SimplexProj(G*WTilde);
    YHatTest = SimplexProj(GTest*WTilde);
%     fit the residual
    W = cholLowerX'\(cholLowerX\(X'*(Y-YHat)));
    prevYTilde = YTilde;
    YTilde = YHat+X*W;
    YTildeTest = YHatTest+XTest*W;
    normDiff = norm(prevYTilde-YTilde,'fro')/sqrt(n*k);
    if normDiff < 0.002
        break
    end
end
model.W = W;
model.WTilde = WTilde;
[~,YHatTrain] = max(YHat,[],2);
[~,YHatTest] = max(YHatTest,[],2);
trainAccuracy = sum(YHatTrain == YCat)/n;
testAccuracy = sum(YHatTest == YTestCat)/n;
fprintf('Training accuracy: %f\nTest accuracy: %f\n',trainAccuracy,testAccuracy);
end