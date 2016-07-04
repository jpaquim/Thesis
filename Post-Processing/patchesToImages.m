function imageData = patchesToImages(patchData,imgSize,indImg)
%PATCHESTOIMAGES Converts 
%   imageData = PATCHESTOIMAGES(patchData,imgSize,indImg)
%   Converts a multiple images given either as different columns of the same
%   matrix, or as fixed length sections of the same column into stacks of
%   images, nRows x nCols x nDims. If indImg is given, all of the columns
%   associated with the specified image are returned. If it's not given, the
%   patchData matrix must be a single column, and all of the different images
%   in that column are returned.

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
