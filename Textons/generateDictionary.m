function textons = generateDictionary(cfg)
%GENERATEDICTIONARY Summary of this function goes here
%   Detailed explanation goes here

rng(0); % seed random number generator for consistent performance in tests

nFiles = 'all';
imgFiles = dataFilePaths('training',nFiles,true); % load shuffled image files
nFiles = length(imgFiles);

% maximum possible position of a texture's upper left corner
maxULCorner = [cfg.height-cfg.txtHeight+1;
               cfg.width-cfg.txtWidth+1];
if isscalar(cfg.nTextures) % extract only a random subset of all textures
    all = false;
    nTextures = cfg.nTextures;
elseif strcmp(cfg.nTextures,'all'); % extract all possible textures
    all = true;
    nTextures = maxULCorner(1)*maxULCorner(2);
%     pre-generate the texture grid for all files
    [ULCols,ULRows] = meshgrid(1:maxULCorner(2),1:maxULCorner(1));
    ULRows = ULRows(:);
    ULCols = ULCols(:);
end
% rows and columns spanned by a patch, starting from its upper left corner
rowRange = 0:cfg.txtHeight-1;
colRange = 0:cfg.txtWidth-1;

% number of channels in a texton
nChannels = 1+2*cfg.txtColor; % 3 if color, 1 if grayscale
% size of texton when reshaped linearly
linSize = cfg.txtHeight*cfg.txtWidth*nChannels;

textons = zeros(linSize,cfg.nTextons);
% textons = 255*rand(linSize,cfg.nTextons);
for i = 1:nFiles
    fprintf('File: %d\n',i);
    img = double(rgb2ycbcr(imread(imgFiles{i})));

%     train a Kohonen self-organizing map for texture clustering

%     learning rate, exponentially decreasing, lower limit of 0.05
    alpha = max(0.5*exp(-3*(i-1)/nFiles),0.05);
    if ~all % generate a different texture grid for each file
%         rows and columns of the upper left corners sampled uniformly
        ULRows = unidrnd(maxULCorner(1),nTextures,1);
        ULCols = unidrnd(maxULCorner(2),nTextures,1);
    end
    for txt = 1:nTextures
        rows = ULRows(txt)+rowRange;
        cols = ULCols(txt)+colRange;
        texture = reshape(img(rows,cols,1:nChannels),linSize,1);
%         find the closest neuron
        distances2 = sum(bsxfun(@minus,texture,textons).^2);
        [~,u] = min(distances2);
%         and update its weights
        textons(:,u) = textons(:,u)+alpha*(texture-textons(:,u));
    end
end

for i = 1:cfg.nTextons
    subplot(5,6,i);
    txt = reshape(textons(:,i),cfg.txtHeight,cfg.txtWidth,nChannels);
    imagesc(txt(:,:,:)); colormap gray;
end
end