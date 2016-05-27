function [imgL,imgR] = rectifyStereoImages(imgL,imgR)
%RECTIFYSTEREOIMAGES Summary of this function goes here
%   Detailed explanation goes here

imgL = rgb2gray(imgL);
imgR = rgb2gray(imgR);

% pointsL = detectHarrisFeatures(imgL);
% pointsR = detectHarrisFeatures(imgR);
pointsL = detectSURFFeatures(imgL,'MetricThreshold',2000);
pointsR = detectSURFFeatures(imgR,'MetricThreshold',2000);
[featuresL,validPointsL] = extractFeatures(imgL,pointsL);
[featuresR,validPointsR] = extractFeatures(imgR,pointsR);
% indexPairs = matchFeatures(featuresL,featuresR);
indexPairs = matchFeatures(featuresL,featuresR,'Metric','SAD',...
                           'MatchThrehold',5);
matchedPointsL = validPointsL(indexPairs(:,1),:);
matchedPointsR = validPointsR(indexPairs(:,2),:);
figure; showMatchedFeatures(imgL,imgR,matchedPointsL,matchedPointsR);
pause;
f = estimateFundamentalMatrix(matchedPointsL,matchedPointsR,...
    'Method','Norm8Point');
[TL,TR] = estimateUncalibratedRectification(f,...
    matchedPointsL,matchedPointsR,size(imgL));
TL = projective2d(TL);
TR = projective2d(TR);
% figure; imshow([imgL imgR]); pause;
imgL = imwarp(imgL,TL,'OutputView',im2ref2d(size(imgL)));
imgR = imwarp(imgR,TR,'OutputView',im2ref2d(size(imgR)));

matchedPointsL = transformPointsForward(TL,matchedPointsL.Location);
matchedPointsR = transformPointsForward(TR,matchedPointsR.Location);
figure; showMatchedFeatures(imgL,imgR,matchedPointsL,matchedPointsR);

figure; imshow([imgL imgR]); pause;

% stereoParams = stereoParameters(T1,T2);
% [imgL,imgR] = rectifyStereoImages(imgL,imgR,stereoParams);

end
