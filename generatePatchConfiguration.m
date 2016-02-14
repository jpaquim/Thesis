function p = generatePatchConfiguration(imageSize,gridSize,patchSize)
%GENERATEPATCHCONFIGURATION Summary of this function goes here
%   Detailed explanation goes here

% image size in pixels
p.height = imageSize(1);
p.width = imageSize(2);
% number of columns and rows in the depth data, corresponding to patches
p.nRows = gridSize(1); 
p.nCols = gridSize(2);
p.nPatches = p.nRows*p.nCols;
% patch size in pixels
p.patchHeight = patchSize(1);
p.patchWidth = patchSize(2);

p.nScales = 3; % number of different size scales
p.halfHeight(1) = floor(p.patchHeight/2);
p.halfHeight(2) = floor(3*p.patchHeight/2);
p.halfHeight(3) = floor(9*p.patchHeight/2);
p.halfWidth(1) = floor(p.patchWidth/2);
p.halfWidth(2) = floor(3*p.patchWidth/2);
p.halfWidth(3) = floor(9*p.patchWidth/2);

% grid of patch centers
p.firstRow = p.halfHeight(1)+1;
p.firstCol = p.halfWidth(1)+1;
p.patchRows = linspace(p.firstRow,p.height-p.firstRow,p.nRows);
p.patchCols = linspace(p.firstCol,p.width-p.firstCol,p.nCols);
p.patchRows = round(p.patchRows);
p.patchCols = round(p.patchCols);
% intervals around the patch center
p.rowInterval = {-p.halfHeight(1):p.halfHeight(1), ...
                 -p.halfHeight(2):p.halfHeight(2), ...
                 -p.halfHeight(3):p.halfHeight(3)};
p.colInterval = {-p.halfWidth(1):p.halfWidth(1), ...
                 -p.halfWidth(2):p.halfWidth(2), ...
                 -p.halfWidth(3):p.halfWidth(3)};

baseSize = patchSize(1)*patchSize(2);
p.linInd = {zeros(p.nPatches,baseSize), ...
          zeros(p.nPatches,9*baseSize), ...
          zeros(p.nPatches,81*baseSize)};

for scl = 1:p.nScales
    for row = 1:p.nRows
        for col = 1:p.nCols
%             how to deal with boundaries?
            indRows = ...
                min(max(p.patchRows(row)+p.rowInterval{scl},1),p.height);
            indCols = ...
                min(max(p.patchCols(col)+p.colInterval{scl},1),p.width);
%             need to expand the indices into matrices,
%             to work correctly with sub2ind
            N = length(indCols);
            indRowsExp = repmat(indRows,1,N);
            aux = repmat(indCols,N,1);
            indColsExp = aux(:)';
%             convert the row,col subscripts into linear indices
            p.linInd{scl}(row+(col-1)*p.nRows,:) = ...
                sub2ind(imageSize,indRowsExp,indColsExp);
        end
    end
end
end