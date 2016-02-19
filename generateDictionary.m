function textons = generateDictionary()
%GENERATEDICTIONARY Summary of this function goes here
%   Detailed explanation goes here

[imgFiles,depthFiles] = dataFilePaths('training');
nFiles = length(imgFiles);
% nFiles = 2;

imgInfo = imfinfo(imgFiles{1}); % read resolution from the first image
% a structure whose fields contain the configuration of the textons
t = textonConfiguration([imgInfo.Height imgInfo.Width],[5 5],200);

nInstances = nFiles*t.nTextons;
textons = zeros(t.textonHeight,t.textonWidth,3,nInstances);
for i = 1:nFiles
    fprintf('File: %d\n',i);
    imgRGB = imread(imgFiles{i});
    ind = (1:t.nTextons)+(i-1)*t.nTextons;
    textons(:,:,:,ind) = extractTextons(imgRGB,t);
    
%     load(depthFiles{i});
%     depths = Position3DGrid(:,:,4); %#ok<NODEF>
%     ind = (1:p.nPatches)+(i-1)*p.nPatches;
%     labels(ind) = labelDepths(depths(:));
end
end