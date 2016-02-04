function features = extractFeatures(img,filters,channels,p)
%GENERATEFEATURES Summary of this function goes here
%   Detailed explanation goes here

nFilters = length(channels); % number of filters applied
nFeatures = 2*length(channels);
features = zeros(p.nPatches,nFeatures); % feature vector
for i = 1:nFilters
%     apply the filters to the corresponding image channels
    imgFilt = imfilter(img(:,:,channels(i)),filters{i});
%     imagesc(filters{i}); colormap('gray'); pause;
%     imagesc(imgFilt); pause;
%     split image into patches, calculate the energies for each patch,
    for col = 1:p.nCols
        indCols = p.patchCols(col)+p.colInterval;
        for row = 1:p.nRows
            indRows = p.patchRows(row)+p.rowInterval;
            imgPatch = imgFilt(indRows,indCols);
            ind = row+(col-1)*p.nRows;
            features(ind,i) = sum(abs(imgPatch(:)));
            features(ind,i+nFilters) = sum(imgPatch(:).^2);
%             pause
        end
    end
%     at different size scales
end
end