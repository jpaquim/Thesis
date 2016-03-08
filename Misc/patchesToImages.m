function imageData = patchesToImages(patchData,imgSize,indImg)
%PATCHESTOIMAGES Summary of this function goes here
%   Detailed explanation goes here

nRows = imgSize(1);
nCols = imgSize(2);
nPatches = nRows*nCols;
nDims = size(patchData,2);
if exist('indImg','var') % returns only the selected image, all columns
    ind = (1:nPatches)+(indImg-1)*nPatches;
elseif nDims == 1 % returns all images, limited to a single column
    nTotalPatches = length(patchData);
    ind = 1:nTotalPatches;
    nDims = nTotalPatches/nPatches;
else
    error('Input should be a column vector, if no file specified');
end
% the returned stack consists of different channels of the same image, or
% the different images for a single channel
imageData = reshape(patchData(ind,:),nRows,nCols,nDims);
end