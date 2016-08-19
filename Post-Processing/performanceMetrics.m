function [logError,relativeAbsoluteError,relativeSquareError,...
    rmsLinearError,rmsLogError,scaleInvariantError] = ...
    performanceMetrics(predDepths,depths,dataset)
%PERFORMANCEMETRICS Computes various error metrics between prediction and actual
%depths
%   [logError,relativeAbsoluteError,relativeSquareError,...
%       rmsLinearError,rmsLogError,scaleInvariantError] = ...
%       PERFORMANCEMETRICS(predDepths,depths,type)
%   Computes the mean log error, mean relative absolute error, mean relative
%   square error, RMS linear error, RMS log error, and the RMS scale invariant
%   error by Eigen et al.

d = log(depths)-log(predDepths); % from Eigen et al
n = length(depths);
logError = mean(abs(d));
relativeAbsoluteError = mean(abs(depths-predDepths)./depths);
relativeSquareError = mean((depths-predDepths).^2./depths);
rmsLinearError = rms(depths-predDepths);
rmsLogError = rms(d);
scaleInvariantError = mean(d.^2)-(sum(d)/n).^2;

fprintf('Performance metrics (%s set):\n',dataset);
fprintf(' log error: %f\n',logError);
fprintf(' relative absolute error: %f\n',relativeAbsoluteError);
fprintf(' relative square error: %f\n',relativeSquareError);
fprintf(' RMS linear error: %f\n',rmsLinearError);
fprintf(' RMS log error: %f\n',rmsLogError);
fprintf(' Scale-invariant error: %f\n',scaleInvariantError);
end
