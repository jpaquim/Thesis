function p = patchConfiguration(imageSize,gridSize,patchSize,nScales)
%PATCHCONFIGURATION Summary of this function goes here
%   Detailed explanation goes here

% image size in pixels
p.height = imageSize(1);
p.width = imageSize(2);
% number of columns and rows of patches, corresponding to the depth data
p.nRows = gridSize(1); 
p.nCols = gridSize(2);
p.nPatches = p.nRows*p.nCols;
% patch size in pixels
p.patchHeight = patchSize(1);
p.patchWidth = patchSize(2);

% grid of patch centers
p.firstRow = ceil(p.patchHeight/2);
% p.firstRow = 20;
p.firstCol = ceil(p.patchWidth/2);
% p.firstCol = 20;
p.patchRows = linspace(p.firstRow,p.height-p.firstRow,p.nRows);
p.patchCols = linspace(p.firstCol,p.width-p.firstCol,p.nCols);
p.patchRows = round(p.patchRows);
p.patchCols = round(p.patchCols);

p.nScales = nScales; % number of different size scales
p.indRows = cell(1,p.nScales);
p.indCols = cell(1,p.nScales);
for scl = 1:p.nScales
    p.halfHeight(scl) = floor(3^(scl-1)*p.patchHeight/2);
    p.halfWidth(scl) = floor(3^(scl-1)*p.patchWidth/2);
%     ranges around the patch center
    rowRange = -p.halfHeight(scl):p.halfHeight(scl);
    colRange = -p.halfWidth(scl):p.halfWidth(scl);
    p.indRows{scl} = zeros(length(rowRange),p.nPatches);
    p.indCols{scl} = zeros(length(colRange),p.nPatches);
    for row = 1:p.nRows
        for col = 1:p.nCols
            ind = row+(col-1)*p.nRows;
%             how to deal with boundaries?
            p.indRows{scl}(:,ind) = ...
                min(max(p.patchRows(row)+rowRange,1),p.height);
            p.indCols{scl}(:,ind) = ...
                min(max(p.patchCols(col)+colRange,1),p.width);
        end
    end
end
end