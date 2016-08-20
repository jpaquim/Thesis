function features = extractImgFeatures(imgRGB,filters,channels,textons,cfg)
%EXTRACTIMGFEATURES Summary of this function goes here
%   Detailed explanation goes here

imgYCbCr = double(rgb2ycbcr(imgRGB)); % convert to YCbCr color space
% Coordinate features
if cfg.useFeatures(1)
    posFeatures = cfg.ptcCenters;
else
    posFeatures = [];
end
% Filter-based features
if cfg.useFeatures(2)
    fltFeatures = extractFltFeatures(imgYCbCr,filters,channels,cfg);
else
    fltFeatures = [];
end
% HOG features
if cfg.useFeatures(3)
    % extract HOG features
    % TODO: also use cfg.stepSize in a sensible way here:
    HOGFeatures = extractHOGFeaturesReshaped(imgRGB,cfg);
else
    HOGFeatures = [];
end
% Texton, Radon, and Structure tensor features
if any(cfg.useFeatures(4:6))
    [txtFeatures,radonFeatures,structFeatures] = ...
        extractOtherFeatures(imgYCbCr,textons,cfg);
else
    txtFeatures = []; radonFeatures = []; structFeatures = [];
end
features = [posFeatures fltFeatures HOGFeatures txtFeatures radonFeatures structFeatures];
features = features(1:cfg.stepSize:cfg.nPatches, :);
end