function t = textonConfiguration(imageSize,textonSize,...
                                 nTextons,nTextures,color)
%TEXTONCONFIGURATION Summary of this function goes here
%   Detailed explanation goes here

% image size in pixels
t.height = imageSize(1);
t.width = imageSize(2);

% texton size in pixels
t.txtHeight = textonSize(1);
t.txtWidth = textonSize(2);

% maximum possible position of a patch's upper left corner
t.maxULCorner = [t.height-t.txtHeight+1;
                 t.width-t.txtWidth+1];

% rows and columns spanned by a patch, starting from its upper left corner
t.rowRange = 0:t.txtHeight-1;
t.colRange = 0:t.txtWidth-1;

t.nTextons = nTextons; % number of textons learned

t.all = (nTextures == -1); % code to request all the textures in an image
if t.all
    t.nTextures = t.maxULCorner(1)*t.maxULCorner(2);
    [ULCols,ULRows] = meshgrid(1:t.maxULCorner(2),1:t.maxULCorner(1));
    t.ULCorners = [ULRows(:) ULCols(:)];
else
    t.nTextures = nTextures; % number of textures extracted per image
end

t.color = color;

 % size of texton when reshaped linearly (*3 if color, *1 if grayscale)
t.linSize = t.txtHeight*t.txtWidth*(1+2*color);
end