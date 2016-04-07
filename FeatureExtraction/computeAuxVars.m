function cfg = computeAuxVars(cfg)
%COMPUTEAUXVARS Summary of this function goes here
%   Detailed explanation goes here

% grid of patch centers
firstPtcRow = ceil(3^(cfg.nScales-1)*cfg.ptcHeight/2);
% firstRow = ceil(cfg.ptcHeight/2);
% firstRow = 20;
firstPtcCol = ceil(3^(cfg.nScales-1)*cfg.ptcWidth/2);
% firstCol = ceil(cfg.ptcWidth/2);
% firstCol = 20;
centerRows = linspace(firstPtcRow,cfg.height-firstPtcRow,cfg.nRows);
centerCols = linspace(firstPtcCol,cfg.width-firstPtcCol,cfg.nCols);
[centerCols,centerRows] = meshgrid(round(centerCols),round(centerRows));
centerRows = centerRows(:);
centerCols = centerCols(:);
cfg.ptcCenters = [centerRows centerCols];

txtHalfHeight = floor(cfg.txtHeight/2);
txtHalfWidth  = floor(cfg.txtWidth/2);
txtRowRange = -txtHalfHeight:txtHalfHeight;
txtColRange = -txtHalfWidth:txtHalfWidth;

cfg.ptcRows = cell(1,cfg.nScales);
cfg.ptcCols = cell(1,cfg.nScales);
cfg.txtRows = zeros(length(txtRowRange),cfg.nPatches);
cfg.txtCols = zeros(length(txtColRange),cfg.nPatches);
for scl = 1:cfg.nScales
    halfHeight = floor(3^(scl-1)*cfg.ptcHeight/2);
    halfWidth = floor(3^(scl-1)*cfg.ptcWidth/2);
%     range of rows and columns around the patch centers
    ptcRowRange = -halfHeight:halfHeight;
    ptcColRange = -halfWidth:halfWidth;
    cfg.ptcRows{scl} = zeros(length(ptcRowRange),cfg.nPatches);
    cfg.ptcCols{scl} = zeros(length(ptcColRange),cfg.nPatches);
    for ptc = 1:cfg.nPatches
        cfg.ptcRows{scl}(:,ptc) = centerRows(ptc)+ptcRowRange;
        cfg.ptcCols{scl}(:,ptc) = centerCols(ptc)+ptcColRange;
        if scl == 1
            cfg.txtRows(:,ptc) = centerRows(ptc)+txtRowRange;
            cfg.txtCols(:,ptc) = centerCols(ptc)+txtColRange;
        end
    end
end

% structure of vector returned by the extractHOGFeatures function
%  1   3  N+1 N+3 ...
%  2   4  N+2 N+4 ...
%  5   7  N+5 N+7 ...
%  6   8  N+6 N+8 ...
% ... ... ... ...
% cfg.cellSize = cfg.ptcSize;
cfg.cellSize = [5 5];
nHOGCols = floor(cfg.width/cfg.cellSize(1));
nHOGRows = floor(cfg.height/cfg.cellSize(2));
HOGSize = nHOGCols*nHOGRows;
ind0 = 1:HOGSize;
ind1 = sort([ind0(1:4:end);ind0(2:4:end)]);
ind2 = sort([ind0(3:4:end);ind0(4:4:end)]);
ind3(:,1:2:nHOGCols) = reshape(ind1,nHOGRows,[]);
ind3(:,2:2:nHOGCols) = reshape(ind2,nHOGRows,[]);
ind4 = repmat(ind3,1,1,cfg.nHOGBins);
cfg.indHOG = zeros(nHOGRows,nHOGCols,cfg.nHOGBins);
for i = 1:cfg.nHOGBins
    cfg.indHOG(:,:,i) = ind4(:,:,i)+(i-1)*HOGSize;
end
end