function features = extractImgFeatures(imgRGB,filters,channels,textons,cfg)
%EXTRACTIMGFEATURES Summary of this function goes here
%   Detailed explanation goes here

img = double(rgb2ycbcr(imgRGB)); % convert to YCbCr color space

% Filter-based features
nFilters = length(channels); % number of filters applied
nFltFeatures = 2*cfg.nScales*length(channels);
fltFeatures = zeros(cfg.nPatches,nFltFeatures);
for flt = 1:nFilters
%     apply the filters to the corresponding image channels
    imgFilt = imfilter(img(:,:,channels(flt)),filters{flt},...
                       'symmetric','conv');
    for scl = 1:cfg.nScales
        for ptc = 1:cfg.nPatches
            imgPatch = ...
                imgFilt(cfg.ptcRows{scl}(:,ptc),cfg.ptcCols{scl}(:,ptc));
            feat = 2*(scl+(flt-1)*cfg.nScales);
%             calculate the energies for each patch
            fltFeatures(ptc,feat-1) = sum(abs(imgPatch(:)));
            fltFeatures(ptc,feat) = sum(imgPatch(:).^2);
        end
    end
end

% Texton-based features (square Euclidean distance to each texton)
nTextons = size(textons,2);
txtFeatures = zeros(cfg.nPatches,nTextons);
% HOGFeatures = zeros(cfg.nPatches,cfg.nHOGBins);
% txtCenter = ceil(cfg.txtSize/2);
for ptc = 1:cfg.nPatches
    imgPatch = img(cfg.txtRows(:,ptc),cfg.txtCols(:,ptc),1);
    texture = reshape(imgPatch,[],1);
    txtFeatures(ptc,:) = sum(bsxfun(@minus,texture,textons).^2)';
%     HOGFeatures(ptc,:) = extractHOGFeatures(imgPatch,...
%         txtCenter,'CellSize',txtCenter,'BlockSize',[1 1]);
end

% HOG features
% extractHOGFeatures returns a vector of features for the whole image, this
% code converts the vector to a stack of matrices, resizes it to the grid
% size, and then reshapes it to the right format, nPatches x nHOGBins
HOGVec = extractHOGFeatures(imgRGB,'CellSize',cfg.cellSize,...
                            'BlockOverlap',[0 0],'NumBins',cfg.nHOGBins);
HOGAux = permute(reshape(HOGVec,cfg.nHOGBins,[]),[2 3 1]);
HOGAux = HOGAux(cfg.indHOG);
HOGMat = imresize(HOGAux,cfg.mapSize,'nearest');
HOGFeatures = reshape(HOGMat,[],cfg.nHOGBins);
features = [fltFeatures txtFeatures HOGFeatures cfg.ptcCenters];
end