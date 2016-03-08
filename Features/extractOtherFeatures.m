function [txtFeatures,radonFeatures,structFeatures] = ...
    extractOtherFeatures(imgYCbCr,textons,cfg)
%EXTRACTOTHERFEATURES Summary of this function goes here
%   Detailed explanation goes here

imgGray = imgYCbCr(:,:,1); % intensity channel, grayscale image

computeTextons = cfg.useFeatures(4);
computeRadon = cfg.useFeatures(5);
computeStruct = cfg.useFeatures(6);

% Texton-based features (square Euclidean distance to each texton)
if computeTextons
    nTextons = size(textons,2);
    txtFeatures = zeros(cfg.nPatches,nTextons);
else
    txtFeatures = [];
end
if computeRadon
    radonAngles = linspace(0,179,cfg.nRadonAngles);
    radonFeatures = zeros(cfg.nPatches,2*cfg.nRadonAngles);
else
    radonFeatures = [];
end
if computeStruct
    structAngleBins = pi*(0:1/cfg.nStructBins:1-1/cfg.nStructBins);
    hSize = 5; sigma = 1;
    [filtDerivX,filtDerivY] = gradient(fspecial('gaussian',hSize,sigma));
    imgDerivX = imfilter(imgYCbCr,filtDerivX,'symmetric','conv');
    imgDerivY = imfilter(imgYCbCr,filtDerivY,'symmetric','conv');
    structFeatures = zeros(cfg.nPatches,cfg.nStructBins);
else
    structFeatures = [];
end

for ptc = 1:cfg.nPatches
    imgPatch = imgYCbCr(cfg.txtRows(:,ptc),cfg.txtCols(:,ptc),1);
    if computeTextons
        texture = reshape(imgPatch,[],1);
        txtFeatures(ptc,:) = sum(bsxfun(@minus,texture,textons).^2)';
    end
    
%     Radon transform based features
%     TODO: low resolution, experiment with bigger patches
    if computeRadon
        sortedRadonTransform = sort(radon(imgPatch,radonAngles));
        radonFeatures(ptc,:) = reshape(sortedRadonTransform(end-1:end,:),[],1);
    end
    if computeStruct
%     Structure tensor features
%     TODO: loop over small patches within a window and build histogram
    imgPatchDerivX = imgDerivX(cfg.txtRows(:,ptc),cfg.txtCols(:,ptc),1);
    imgPatchDerivY = imgDerivY(cfg.txtRows(:,ptc),cfg.txtCols(:,ptc),1);
    IXX = imgPatchDerivX.*imgPatchDerivX;
    IXY = imgPatchDerivX.*imgPatchDerivY;
    IYY = imgPatchDerivY.*imgPatchDerivY;
    structureTensor = [sum(IXX(:)) sum(IXY(:));
                       sum(IXY(:)) sum(IYY(:))];
    [eigVectors,eigValues] = eig(structureTensor);
    eigValues = diag(eigValues);
    angle = acos(dot(eigVectors(:,1),eigVectors(:,2))); % eigenvectors are always orthogonal
    ind = interp1(structAngleBins,1:cfg.nStructBins,angle,'nearest');
%     eigHistogram(ind) = eigHistogram(ind)+eigValues(1)+eigValues(2);
%     structTensorFeatures(ptc,:) = eigHistogram;
    structFeatures(ptc,ind) = eigValues(1)+eigValues(2);
    end
end

end