function HOGFeatures = extractHOGFeaturesReshaped(imgRGB,cfg)
%MYEXTRACTHOGFEATURES Summary of this function goes here
%   Detailed explanation goes here

% extractHOGFeatures returns a vector of features for the whole image, this
% code converts the vector to a stack of matrices, resizes it to the grid
% size, and then reshapes it to the right format, nPatches x nHOGBins
HOGVec = extractHOGFeatures(imgRGB,'CellSize',cfg.cellSize,...
                            'BlockOverlap',[0 0],'NumBins',cfg.nHOGBins);
HOGAux = permute(reshape(HOGVec,cfg.nHOGBins,[]),[2 3 1]);
HOGAux = HOGAux(cfg.indHOG);
HOGMat = imresize(HOGAux,cfg.mapSize,'nearest');
HOGFeatures = reshape(HOGMat,[],cfg.nHOGBins);
% visualize HOG feature maps
% for i = 1:cfg.nHOGBins
%     HOGMap = patchesToImages(HOGFeatures,cfg.mapSize,1);
%     imagesc(HOGMap(:,:,i));
%     pause;
% end
end
