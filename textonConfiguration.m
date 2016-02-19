function t = textonConfiguration(imageSize,textonSize,nTextons)
%TEXTONCONFIGURATION Summary of this function goes here
%   Detailed explanation goes here

% image size in pixels
t.height = imageSize(1);
t.width = imageSize(2);

% texton size in pixels
t.textonHeight = textonSize(1);
t.textonWidth = textonSize(2);
t.nTextons = nTextons; % number of textons per image

t.rowRange = 0:t.textonHeight-1;
t.colRange = 0:t.textonWidth-1;

end