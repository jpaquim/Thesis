function textons = generateDictionary(t)
%GENERATEDICTIONARY Summary of this function goes here
%   Detailed explanation goes here

rng(0); % seed random number generator for consistent performance in tests

imgFiles = dataFilePaths('training',[],true); % load shuffled image files
nFiles = length(imgFiles);
% nFiles = 10; % for testing purposes

textons = zeros(t.linSize,t.nTextons);
% textons = 255*rand(t.linSize,t.nTextons);
for i = 1:nFiles
    fprintf('File: %d\n',i);
    img = double(rgb2ycbcr(imread(imgFiles{i})));
    if ~t.color % use only the intensity channel
        img = img(:,:,1);
    end
%     train a Kohonen self-organizing map for texture clustering
%     learning rate, exponentially decreasing, lower limit of 0.05
    alpha = max(0.5*exp(-3*(i-1)/nFiles),0.05);
    
%     rows and columns of the upper left corners sampled uniformly
    ULRows = unidrnd(t.maxULCorner(1),t.nTextures,1);
    ULCols = unidrnd(t.maxULCorner(2),t.nTextures,1);
    for txt = 1:t.nTextures
        rows = ULRows(txt)+t.rowRange;
        cols = ULCols(txt)+t.colRange;
        texture = reshape(img(rows,cols,:),t.linSize,1);
%         find the closest neuron and update its weights
        distances2 = sum(bsxfun(@minus,texture,textons).^2);
        [~,u] = min(distances2);
        textons(:,u) = textons(:,u)+alpha*(texture-textons(:,u));
    end
end

for i = 1:t.nTextons
    subplot(5,6,i);
    txt = reshape(textons(:,i),t.txtHeight,t.txtWidth,1+2*t.color);
    imagesc(txt(:,:,:)); colormap gray;
end
end