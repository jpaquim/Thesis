function p = patchConfiguration()
%PATCHCONFIGURATION Summary of this function goes here
%   Detailed explanation goes here

p.nRows = 305; % columns in the depth data, number of patches horizontally
p.nCols = 55; % rows in the depth data, number of patches vertically
p.nPatches = p.nRows*p.nCols;
p.height = 2272;
p.width = 1704;
p.patchHeight = 11;
p.patchWidth = 11;
p.halfHeight = floor(p.patchHeight/2);
p.halfWidth = floor(p.patchWidth/2);
p.patchRows = round(linspace(p.halfHeight+1,p.height-p.halfHeight-1,p.nRows));
p.patchCols = round(linspace(p.halfWidth+1,p.width-p.halfWidth-1,p.nCols));
p.rowInterval = -p.halfHeight:p.halfHeight;
p.colInterval = -p.halfWidth:p.halfWidth;
end