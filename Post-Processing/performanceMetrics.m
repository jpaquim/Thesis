function [lnError,log10Error,relError,rmsError] = ...
    performanceMetrics(predDepths,depths,type)
%PERFORMANCEMETRICS Summary of this function goes here
%   Detailed explanation goes here

lnError = mean(abs(log(depths)-log(predDepths)));
log10Error = mean(abs(log10(depths)-log10(predDepths)));
relError = mean(abs((depths-predDepths)./depths));
rmsError = rms(depths-predDepths);

fprintf('Performance metrics (%s set):\n',type);
fprintf(' ln error: %f\n',lnError);
fprintf(' log10 error: %f\n',log10Error);
fprintf(' relative error: %f\n',relError);
fprintf(' RMS error: %f\n',rmsError);
end