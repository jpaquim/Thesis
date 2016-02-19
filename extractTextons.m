function textons = extractTextons(imgRGB,t)
%EXTRACTTEXTONS Summary of this function goes here
%   Detailed explanation goes here

upperLeftCorners(:,1) = unidrnd(t.height-t.textonHeight+1,t.nTextons,1);
upperLeftCorners(:,2) = unidrnd(t.width-t.textonWidth+1,t.nTextons,1);

textons = zeros(t.textonHeight,t.textonWidth,3,t.nTextons);
for txt = 1:t.nTextons
    rows = upperLeftCorners(txt,1)+t.rowRange;
    cols = upperLeftCorners(txt,2)+t.colRange;
    textons(:,:,:,txt) = imgRGB(rows,cols,:);
end
end