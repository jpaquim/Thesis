% converts the data sets to the same format, similar to Make3D

% Make3D train
imgPrefix = './data/TrainImgMake3D/';
depthPrefix = './data/TrainDepthMake3D/';
if ~exist(imgPrefix,'file') || ~exist(depthPrefix,'file')
    folderPrefix = './data/Make3D/';
    imgFolder = 'Train400Img/';
    depthFolder = 'Train400Depth/';
    imgFolder = [folderPrefix imgFolder];
    depthFolder = [folderPrefix depthFolder];
    dirFiles = dir([imgFolder '*.jpg']);
    imgFiles = strcat(imgFolder,{dirFiles.name}');
    dirFiles = dir([depthFolder '*.mat']);
    depthFiles = strcat(depthFolder,{dirFiles.name}');
    nFiles = length(imgFiles);
    if nFiles ~= length(depthFiles) % basic error checking
        error('Unbalanced image and depth data');
    end
    mkdir(imgPrefix);
    mkdir(depthPrefix);
    for i = 1:nFiles
        fileName = num2str(i,'%04d');
        imageData = imread(imgFiles{i});
        imwrite(imageData,[imgPrefix fileName '.png']);
        load(depthFiles{i});
        depth = Position3DGrid(:,:,4);
        save([depthPrefix fileName '.mat'],'depth');
    end
end

% Make3D test
imgPrefix = './data/TestImgMake3D/';
depthPrefix = './data/TestDepthMake3D/';
if ~exist(imgPrefix,'file') || ~exist(depthPrefix,'file')
    folderPrefix = './data/Make3D/';
    imgFolder = 'Test134/';
    depthFolder = 'Gridlaserdata/';
    imgFolder = [folderPrefix imgFolder];
    depthFolder = [folderPrefix depthFolder];
    dirFiles = dir([imgFolder '*.jpg']);
    imgFiles = strcat(imgFolder,{dirFiles.name}');
    dirFiles = dir([depthFolder '*.mat']);
    depthFiles = strcat(depthFolder,{dirFiles.name}');
    nFiles = length(imgFiles);
    if nFiles ~= length(depthFiles) % basic error checking
        error('Unbalanced image and depth data');
    end
    mkdir(imgPrefix);
    mkdir(depthPrefix);
    for i = 1:nFiles
        fileName = num2str(i,'%04d');
        imageData = imread(imgFiles{i});
        imwrite(imageData,[imgPrefix fileName '.png']);
        load(depthFiles{i});
        depth = Position3DGrid(:,:,4);
        save([depthPrefix fileName '.mat'],'depth');
    end
end

% KITTI
trainPortion = 0.7; % portion allocated to the training set
imgTrainPrefix = './data/TrainImgKITTI/';
depthTrainPrefix = './data/TrainDepthKITTI/';
imgTestPrefix = './data/TestImgKITTI/';
depthTestPrefix = './data/TestDepthKITTI/';
nTrain = 0;
nTest = 0;
if ~exist(imgTrainPrefix,'file') || ~exist(depthTrainPrefix,'file') || ...
   ~exist(imgTestPrefix,'file') || ~exist(depthTestPrefix,'file')
    folderPrefix = './data/KITTI/training/';
    imgFolder = 'image_2/'; % left camera images
    depthFolder = 'disp_occ_0/';
    imgFolder = [folderPrefix imgFolder];
    depthFolder = [folderPrefix depthFolder];
    dirFiles = dir([imgFolder '*0.png']); % only the first of the image pairs
    imgFiles = strcat(imgFolder,{dirFiles.name}');
    dirFiles = dir([depthFolder '*.png']);
    depthFiles = strcat(depthFolder,{dirFiles.name}');
    nFiles = length(imgFiles);
    if nFiles ~= length(depthFiles) % basic error checking
        error('Unbalanced image and depth data');
    end
    mkdir(imgTrainPrefix);
    mkdir(depthTrainPrefix);
    mkdir(imgTestPrefix);
    mkdir(depthTestPrefix);
    for i = 1:nFiles
        if rand() < trainPortion
            imgPrefix = imgTrainPrefix;
            depthPrefix = depthTrainPrefix;
            nTrain = nTrain+1;
            n = nTrain;
        else
            imgPrefix = imgTestPrefix;
            depthPrefix = depthTestPrefix;
            nTest = nTest+1;
            n = nTest;
        end
        fileName = num2str(n,'%04d');
        copyfile(imgFiles{i},[imgPrefix fileName '.png']);
        depth = imread(depthFiles{i});
        save([depthPrefix fileName '.mat'],'depth');
    end
end

% NYU Depth V2
imgTrainPrefix = './data/TrainImgNYU/';
depthTrainPrefix = './data/TrainDepthNYU/';
imgTestPrefix = './data/TestImgNYU/';
depthTestPrefix = './data/TestDepthNYU/';
if ~exist(imgTrainPrefix,'file') || ~exist(depthTrainPrefix,'file') || ...
   ~exist(imgTestPrefix,'file') || ~exist(depthTestPrefix,'file')
    mkdir(imgTrainPrefix);
    mkdir(depthTrainPrefix);
    mkdir(imgTestPrefix);
    mkdir(depthTestPrefix);
    load('./data/NYUDepthV2/nyu_depth_v2_labeled.mat');
    nFiles = size(images,4);
    for i = 1:nFiles
        if rand() < trainPortion
            imgPrefix = imgTrainPrefix;
            depthPrefix = depthTrainPrefix;
            nTrain = nTrain+1;
            n = nTrain;
        else
            imgPrefix = imgTestPrefix;
            depthPrefix = depthTestPrefix;
            nTest = nTest+1;
            n = nTest;
        end
        fileName = num2str(n,'%04d');
        imwrite(images(:,:,:,i),[imgPrefix fileName '.png']);
        depth = depths(:,:,i);
        save([depthPrefix fileName '.mat'],'depth');
    end
end

% Stereo data sets



clear;
