function model = multiLogisticLS(X,Y)
%MULTILOGISTICLS Performs classification using an iterative least squares
%algorithm
%   model = MULTILOGISTICLS(X,Y)
%   The algorithm is described in Agarwal, Kakade, et al. - Least Squares
%   Revisited: Scalable Approaches for Multi-Class Prediction.
%   This implementation is a slightly modified version of the code found here:
%   https://github.com/fest/secondorderdemos


[d,n] = size(X);
k = size(Y,1);
W = zeros(k,d);
invSigma = inv(X*X'/n); % inverse of the sample second order moment matrix
maxIters = 10000;
for t = 1:maxIters
    WPrev = W;
    YHat = bsxfun(@rdivide,exp(W*X),(1+sum(exp(W*X))));
    W = W-(YHat-Y)*X'*invSigma/n;
    relativeChange = abs((W-WPrev)./WPrev);
    if all(relativeChange < 1e-2)
        fprintf('Convergence: Iteration %d\n',t);
        break;
    end
end
model = W;
YHat = bsxfun(@rdivide,exp(W*X),(1+sum(exp(W*X))));
accuracy = sum(sum(Y.*(YHat>0.5)))/100;
end
