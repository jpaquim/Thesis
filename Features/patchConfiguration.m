function p = patchConfiguration(cfg)
%PATCHCONFIGURATION Summary of this function goes here
%   Detailed explanation goes here

p.nPatches = cfg.nPatches;
p.nScales = cfg.nScales;

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

txtHalfHeight = floor(cfg.txtHeight/2);
txtHalfWidth = floor(cfg.txtWidth/2);
txtRowRange = -txtHalfHeight:txtHalfHeight;
txtColRange = -txtHalfWidth:txtHalfWidth;

p.ptcRows = cell(1,cfg.nScales);
p.ptcCols = cell(1,cfg.nScales);
p.txtRows = zeros(length(txtRowRange),cfg.nPatches,'uint16');
p.txtCols = zeros(length(txtColRange),cfg.nPatches,'uint16');
for scl = 1:cfg.nScales
    halfHeight = floor(3^(scl-1)*cfg.ptcHeight/2);
    halfWidth = floor(3^(scl-1)*cfg.ptcWidth/2);
%     range of rows and columns around the patch centers
    ptcRowRange = -halfHeight:halfHeight;
    ptcColRange = -halfWidth:halfWidth;
    p.ptcRows{scl} = zeros(length(ptcRowRange),cfg.nPatches,'uint16');
    p.ptcCols{scl} = zeros(length(ptcColRange),cfg.nPatches,'uint16');
    for ptc = 1:cfg.nPatches
        p.ptcRows{scl}(:,ptc) = centerRows(ptc)+ptcRowRange;
        p.ptcCols{scl}(:,ptc) = centerCols(ptc)+ptcColRange;
        if scl == 1
            p.txtRows(:,ptc) = centerRows(ptc)+txtRowRange;
            p.txtCols(:,ptc) = centerCols(ptc)+txtColRange;
        end
    end
end
end