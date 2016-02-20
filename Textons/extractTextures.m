function textures = extractTextures(img,t)
%EXTRACTTEXTURES Summary of this function goes here
%   Detailed explanation goes here

if t.all % if every patch requested, use the pregenerated corner grid
    ULCorners = t.ULCorners;
else % sample the upper left corners from a uniform distribution
    ULCorners(:,1) = unidrnd(t.maxULCorner(1),t.nTextures,1);
    ULCorners(:,2) = unidrnd(t.maxULCorner(2),t.nTextures,1);
end
textures = zeros(t.linSize,t.nTextures);
for txt = 1:t.nTextures
    rows = ULCorners(txt,1)+t.rowRange;
    cols = ULCorners(txt,2)+t.colRange;
    textures(:,txt) = reshape(img(rows,cols,:),t.linSize,1);
end
end