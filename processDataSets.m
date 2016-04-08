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
        imgName = num2str(i,'%04d.png');
        depthName = num2str(i,'%04d.mat');
        imageData = imread(imgFiles{i});
        imwrite(imageData,[imgPrefix imgName]);
        load(depthFiles{i});
        depth = Position3DGrid(:,:,4);
        save([depthPrefix depthName],'depth');
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
        imgName = num2str(i,'%04d.png');
        depthName = num2str(i,'%04d.mat');
        imageData = imread(imgFiles{i});
        imwrite(imageData,[imgPrefix imgName]);
        load(depthFiles{i});
        depth = Position3DGrid(:,:,4);
        save([depthPrefix depthName],'depth');
    end
end

% KITTI
imgPrefix = './data/TrainImgKITTI/';
depthPrefix = './data/TrainDepthKITTI/';
if ~exist(imgPrefix,'file') || ~exist(depthPrefix,'file')
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
    mkdir(imgPrefix);
    mkdir(depthPrefix);
    for i = 1:nFiles
        imgName = num2str(i,'%04d.png');
        depthName = num2str(i,'%04d.mat');
        copyfile(imgFiles{i},[imgPrefix imgName]);
        depth = imread(depthFiles{i});
        save([depthPrefix depthName],'depth');
    end
end

% NYU Depth V2
imgPrefix = './data/TrainImgNYU/';
depthPrefix = './data/TrainDepthNYU/';
if ~exist(imgPrefix,'file') || ~exist(depthPrefix,'file')
    mkdir(imgPrefix);
    mkdir(depthPrefix);
    load('./data/NYUDepthV2/nyu_depth_v2_labeled.mat');
    nFiles = size(images,4);
    for i = 1:nFiles
        fileName = num2str(i,'%04d');
        imwrite(images(:,:,:,i),[imgPrefix fileName '.png']);
        depth = depths(:,:,i);
        save([depthPrefix fileName '.mat'],'depth');
    end
end

% Stereo data sets



% clear;
