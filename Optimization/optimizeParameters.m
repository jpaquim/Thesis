function cfgOpt = optimizeParameters()
%OPTIMIZEPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

% cost function for the optimization solver
costFun = @(parameterVec) costFunctionParameters(parameterVec);
% optimization options
lowerBounds = [1 1 20 9 15 15 2 10];
upperBounds = [7 7 50 9 15 15 2 10];
nParams = length(lowerBounds);
intConstraints = 1:nParams; % every parameter is an integer
options = gaoptimset();
% solve the optimization problem
parameterVec = ga(costFun,nParams,[],[],[],[],...
                  lowerBounds,upperBounds,[],intConstraints,options);
cfg = defaultConfig();
cfgOpt = updateConfig(cfg,parameterVec);
end