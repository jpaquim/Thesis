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

% grid of patch centers
p.firstRow = ceil(p.patchHeight/2);
p.firstCol = ceil(p.patchWidth/2);
p.patchRows = linspace(p.firstRow,p.height-p.firstRow,p.nRows);
p.patchCols = linspace(p.firstCol,p.width-p.firstCol,p.nCols);
p.patchRows = round(p.patchRows);
p.patchCols = round(p.patchCols);

patchArea = patchSize(1)*patchSize(2);
p.nScales = 3; % number of different size scales
p.linInd = cell(1,p.nScales);
for scl = 1:p.nScales
    p.halfHeight(scl) = floor(3^(scl-1)*p.patchHeight/2);
    p.halfWidth(scl) = floor(3^(scl-1)*p.patchWidth/2);
%     pixel ranges around the patch center
    rowRange = -p.halfHeight(scl):p.halfHeight(scl);
    colRange = -p.halfWidth(scl):p.halfWidth(scl);
%     initialization of the linear indices
    p.linInd{scl} = zeros(3^(2*(scl-1))*patchArea,p.nPatches);
    for row = 1:p.nRows
        for col = 1:p.nCols
%             how to deal with boundaries?
            indRows = ...
                min(max(p.patchRows(row)+rowRange,1),p.height);
            indCols = ...
                min(max(p.patchCols(col)+colRange,1),p.width);
%             need to expand the indices into matrices,
%             to work correctly with sub2ind
            N = length(indCols);
            indRowsExp = repmat(indRows,1,N);
            aux = repmat(indCols,N,1);
            indColsExp = aux(:)';
%             convert the row,col subscripts into linear indices
            p.linInd{scl}(:,row+(col-1)*p.nRows) = ...
                sub2ind(imageSize,indRowsExp,indColsExp);
%             currently occupying a lot of memory, possible to use
%             smaller data types, uint16?
        end
    end
end
end