function lambdaOpt = ...
    optimizeRegularization(trainFeatures,trainDepths,modelType)
%OPTIMIZEREGULARIZATION Summary of this function goes here
%   Detailed explanation goes here

% split training data for validation using the holdout method
[trainFeatures,testFeatures,trainDepths,testDepths] = ...
    validationPartition(trainFeatures,trainDepths,0.7);

% cost function for the optimization solver
costFun = @(lambdaVec) costFunctionRegularization(lambdaVec,...
    trainFeatures,trainDepths,testFeatures,testDepths,modelType);
% initial guess
% lambdaVec0 = ones(nFeatures,1);
lambda0 = 1;
% solve the optimization problem
options = optimset('MaxFunEvals',100,'Display','iter');
lambdaOpt = fmincon(costFun,lambda0,[],[],[],[],0,inf,[],options);
% lambdaOpt = fminsearch(costFun,lambdaVec0,options);
% options = optimoptions('fminunc','MaxFunEvals',500,'Display','iter');
% lambdaOpt = fminunc(costFun,lambdaVec0,options);
% lambdaOpt = ga(costFun,size(trainFeatures,2),[],[],[],[],zeros(nFeatures,1),inf(nFeatures,1));
end