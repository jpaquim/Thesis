function features = extractFeatures(imgRGB,filters,channels,textons,p)
%EXTRACTFEATURES Summary of this function goes here
%   Detailed explanation goes here

img = single(rgb2ycbcr(imgRGB)); % convert to YCbCr color space

 % Saxena-based features
nFilters = length(channels); % number of filters applied
nFeaturesSax = 2*p.nScales*length(channels); % sum of abs and sum of square
saxFeatures = zeros(p.nPatches,nFeaturesSax,'single');
for flt = 1:nFilters
%     apply the filters to the corresponding image channels
    imgFilt = imfilter(img(:,:,channels(flt)),filters{flt},...
                       'symmetric','conv');
    for scl = 1:p.nScales
%         split image into patches
        for ptc = 1:p.nPatches
            imgPatch = imgFilt(p.indRows{scl}(:,ptc),p.indCols{scl}(:,ptc));
            feat = 2*(scl+(flt-1)*p.nScales);
%             calculate the energies for each patch
            saxFeatures(ptc,feat-1) = sum(abs(imgPatch(:)));
            saxFeatures(ptc,feat) = sum(imgPatch(:).^2);
        end
    end
end

 % Texton-based features (soft-binning, square Euclidean distance)
nTextons = size(textons,2);
txtFeatures = zeros(p.nPatches,nTextons,'single');
for ptc = 1:p.nPatches
    imgPatch = img(p.indRowsTxt(:,ptc),p.indColsTxt(:,ptc),1);
    texture = reshape(imgPatch,[],1);
    txtFeatures(ptc,:) = sum(bsxfun(@minus,texture,textons).^2)';
end

features = [saxFeatures txtFeatures];

end