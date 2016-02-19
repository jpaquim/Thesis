function features = extractFeatures(imgRGB,filters,channels,p)
%EXTRACTFEATURES Summary of this function goes here
%   Detailed explanation goes here

img = double(rgb2ycbcr(imgRGB)); % convert to YCbCr color space

nFilters = length(channels); % number of filters applied
nFeatures = 2*p.nScales*length(channels);
features = zeros(p.nPatches,nFeatures); % feature vector
for flt = 1:nFilters
%     apply the filters to the corresponding image channels
    imgFilt = imfilter(img(:,:,channels(flt)),filters{flt},...
                       'symmetric','conv');
%     Saxena et al use conv2, with the 'valid' option, and then extend the
%     image back to the original size by replicating the outside pixels
    for scl = 1:p.nScales
%         split image into patches
        for ptc = 1:p.nPatches
            imgPatch = imgFilt(p.indRows{scl}(:,ptc),p.indCols{scl}(:,ptc));
            feat = 2*(scl+(flt-1)*p.nScales);
%             calculate the energies for each patch
            features(ptc,feat-1) = sum(abs(imgPatch(:)));
            features(ptc,feat) = sum(imgPatch(:).^2);
        end
    end
end
end