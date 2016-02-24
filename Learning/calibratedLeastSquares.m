function model = calibratedLeastSquares(X,Y)
%CALIBRATEDLS Summary of this function goes here
%   Detailed explanation goes here

d = size(X,1);
k = size(Y,1);
nIters = 10;
W = zeros(k,d);
YHat = W*X;
for t = 1:nIters
%     YHatPrev = YHat;
%     fit the residual
    t
    W = (X'\(Y-YHat)')';
    YTilde = YHat+W*X;
%     calibrate the predictions
    G = [YTilde;YTilde.^2;YTilde.^3];
    WTilde = (G'\Y')';
    YHat = SimplexProj((WTilde*G)')';
%     if all(abs(YHat(:)-Y(:))<1e-1)
%     if abs(sum(YHat(:)-YHatPrev(:))<1e-1)
%         disp(t)
%         break
%     end
end
model.W = W;
model.WTilde = WTilde;
end

% d = size(X,2);
% k = size(Y,2);
% nIters = 100;
% W = zeros(d,k);
% YHat = X*W;
% for t = 1:nIters
% %     fit the residual
%     W = X\(Y-YHat);
%     YTilde = YHat+X*W;
% %     calibrate the predictions
%     G = [YTilde YTilde.^2];
%     WTilde = G\Y;
%     YHat = SimplexProj(G*WTilde);
% end
% model.W = W;
% model.WTilde = WTilde;
% end