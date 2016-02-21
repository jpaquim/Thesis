function p = patchConfiguration(gridSize,patchSize,nScales,t)
%PATCHCONFIGURATION Summary of this function goes here
%   Detailed explanation goes here

% image size in pixels
p.height = t.height;
p.width = t.width;
% number of columns and rows of patches, corresponding to the depth data
p.nRows = gridSize(1); 
p.nCols = gridSize(2);
p.nPatches = p.nRows*p.nCols;
% patch size in pixels
p.patchHeight = patchSize(1);
p.patchWidth = patchSize(2);

% grid of patch centers
firstRow = ceil(3^(nScales-1)*p.patchHeight/2);
% firstRow = ceil(p.patchHeight/2);
% firstRow = 20;
firstCol = ceil(3^(nScales-1)*p.patchWidth/2);
% firstCol = ceil(p.patchWidth/2);
% firstCol = 20;
p.patchRows = linspace(firstRow,p.height-firstRow,p.nRows);
p.patchCols = linspace(firstCol,p.width-firstCol,p.nCols);
p.patchRows = round(p.patchRows);
p.patchCols = round(p.patchCols);

txtHalfHeight = floor(t.txtHeight/2);
txtHalfWidth = floor(t.txtWidth/2);
txtRowRange = -txtHalfHeight:txtHalfHeight;
txtColRange = -txtHalfWidth:txtHalfWidth;

p.nScales = nScales; % number of different size scales
p.indRows = cell(1,p.nScales);
p.indCols = cell(1,p.nScales);
for scl = 1:p.nScales
    halfHeight = floor(3^(scl-1)*p.patchHeight/2);
    halfWidth = floor(3^(scl-1)*p.patchWidth/2);
%     range of rows and columns around the patch centers
    rowRange = -halfHeight:halfHeight;
    colRange = -halfWidth:halfWidth;
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
            if scl == 1
                p.indRowsTxt(:,ind) = ...
                    min(max(p.patchRows(row)+txtRowRange,1),p.height);
                p.indColsTxt(:,ind) = ...
                    min(max(p.patchCols(col)+txtColRange,1),p.width);
            end
        end
    end
end
end