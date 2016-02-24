function model = logisticLeastSquares(X,Y)
%MULTILOGISTICLS Summary of this function goes here
%   Detailed explanation goes here

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

% [n,d] = size(X);
% k = size(Y,2);
% W = randn(d,k);
% invSigma = inv(X'*X/n); % inverse of the sample second order moment matrix
% nIters = 1000;
% for t = 1:nIters
%     YHat = 1./(1+exp(X*W));
%     W = W-invSigma*X'*(YHat-Y)/n;
% end
% model = W;
% end
