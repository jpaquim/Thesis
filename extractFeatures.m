function features = extractFeatures(img,filters,channels,p)
%EXTRACTFEATURES Summary of this function goes here
%   Detailed explanation goes here

nFilters = length(channels); % number of filters applied
nFeatures = 2*p.nScales*length(channels);
features = zeros(p.nPatches,nFeatures); % feature vector
for i = 1:nFilters
%     apply the filters to the corresponding image channels
    imgFilt = imfilter(img(:,:,channels(i)),filters{i},...
        'symmetric','conv');
%     Saxena et al use conv2, with the 'valid' option, and then extend the
%     image back to the original size by replicating the outside pixels

    for scl = 1:p.nScales % three different size scales
%         split image into patches
        imgPatches = imgFilt(p.linInd{scl});
%         imagesc(reshape(imgPatches(1,:),p.patchSize)); colormap gray; pause;
        ind = 2*(scl+(i-1)*p.nScales);
%         calculate the energies for each patch
        features(:,ind-1) = sum(abs(imgPatches),2);
        features(:,ind) = sum(imgPatches.^2,2);
    end
end
end