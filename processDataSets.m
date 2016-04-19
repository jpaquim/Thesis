% converts the data sets to the same format, similar to Make3D

cd data

% Make3D
imgPrefix = {'TrainImgMake3D/','TestImgMake3D/'};
depthPrefix = {'TrainDepthMake3D/','TestDepthMake3D/'};
folderPrefix = 'Make3D/';
imgFolders = strcat(folderPrefix,{'Train400Img/','Test134/'});
depthFolders = strcat(folderPrefix,{'Train400Depth/','Gridlaserdata/'});
for i = 1:2
    if ~exist(imgPrefix{i},'file') || ~exist(depthPrefix{i},'file')
        dirFiles = dir([imgFolders{i} '*.jpg']);
        imgFiles = strcat(imgFolders{i},{dirFiles.name}');
        dirFiles = dir([depthFolders{i} '*.mat']);
        depthFiles = strcat(depthFolders{i},{dirFiles.name}');
        nFiles = length(imgFiles);
        if nFiles ~= length(depthFiles) % basic error checking
            error('Unbalanced image and depth data');
        end
        mkdir(imgPrefix{i});
        mkdir(depthPrefix{i});
        for j = 1:nFiles
            fileName = num2str(j,'%04d');
            imageData = imread(imgFiles{j});
            imwrite(imageData,[imgPrefix{i} fileName '.png']);
            load(depthFiles{j});
            depth = Position3DGrid(:,:,4);
            save([depthPrefix{i} fileName '.mat'],'depth');
        end
    end
end

% NYU Depth V2
trainPortion = 0.7; % portion allocated to the training set
imgPrefix = {'TrainImgNYU/','TestImgNYU/'};
depthPrefix = {'TrainDepthNYU/','TestDepthNYU/'};
if ~exist(imgPrefix{1},'file') || ~exist(depthPrefix{1},'file') || ...
   ~exist(imgPrefix{2},'file') || ~exist(depthPrefix{2},'file')
    mkdir(imgPrefix{1});
    mkdir(imgPrefix{2});
    mkdir(depthPrefix{1});
    mkdir(depthPrefix{2});
    load('NYUDepthV2/nyu_depth_v2_labeled.mat');
    nFiles = size(images,4);
    n = [0 0];
    for i = 1:nFiles
        j = 1+(rand() > trainPortion); % 1 for training, 2 for test
        n(j) = n(j)+1; % increment corresponding count
        fileName = num2str(n(j),'%04d');
        imwrite(images(:,:,:,i),[imgPrefix{j} fileName '.png']);
        depth = depths(:,:,i);
        save([depthPrefix{j} fileName '.mat'],'depth');
    end
end

% KITTI
trainPortion = 0.7; % portion allocated to the training set
imgPrefix = {'TrainImgKITTI/','TestImgKITTI/'};
dispPrefix = {'TrainDispKITTI/','TestDispKITTI/'};
if ~exist(imgPrefix{1},'file') || ~exist(dispPrefix{1},'file') || ...
   ~exist(imgPrefix{2},'file') || ~exist(dispPrefix{2},'file')
    folderPrefix = 'KITTI/training/';
    imgFolder = [folderPrefix 'image_2/']; % left camera images
    dispFolder = [folderPrefix 'disp_occ_0/'];
    dirFiles = dir([imgFolder '*0.png']); % only the first of the image pairs
    imgFiles = strcat(imgFolder,{dirFiles.name}');
    dirFiles = dir([dispFolder '*.png']);
    dispFiles = strcat(dispFolder,{dirFiles.name}');
    nFiles = length(imgFiles);
    if nFiles ~= length(dispFiles) % basic error checking
        error('Unbalanced image and depth data');
    end
    mkdir(imgPrefix{1});
    mkdir(imgPrefix{2});
    mkdir(dispPrefix{1});
    mkdir(dispPrefix{2});
    n = [0 0];
    for i = 1:nFiles
        j = 1+(rand() > trainPortion); % 1 for training, 2 for test
        n(j) = n(j)+1; % increment corresponding count
        fileName = num2str(n(j),'%04d');
        copyfile(imgFiles{i},[imgPrefix{j} fileName '.png']);
        disps = double(imread(dispFiles{i}))./256.0;
        save([dispPrefix{j} fileName '.mat'],'disps');
    end
end

cd ..;
clear;
