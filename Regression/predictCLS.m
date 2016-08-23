function [YHatTest] = ...
    predictCLS(XTest,model)
%REGRESSIONCLS Performs regression using the Calibrated Least Squares algorithm
%   function [YHatTest] = predictCLS(XTest,model)
%   The algorithm is described in Agarwal, Kakade, et al. - Least Squares
%   Revisited: Scalable Approaches for Multi-Class Prediction.
%   This implementation is a slightly modified version of the code found
%   here: https://github.com/fest/secondorderdemos

Ws = model.Ws;
WTildes = model.WTildes;

[n,d] = size(XTest);
k = size(XTest,2);
% initialize W with the least squares estimate
W = Ws(:,1);
YTildeTest = XTest*W;
maxIters = length(WTildes);
for t = 1:maxIters
%     calibrate the predictions
    GTest = [YTildeTest YTildeTest.^2/2 YTildeTest.^3/6 YTildeTest.^4/24];
    WTilde = WTildes(:,t);
    YHatTest = GTest*WTilde;
%     fit the residual
    W = Ws(:,t+1);
    YTildeTest = YHatTest+XTest*W;
end

YHatTest = real(YHatTest);
YHatTest = exp(YHatTest);
end
