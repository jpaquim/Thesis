% converts the data sets to the same format, pairs of '-img' and '-depth'
% folders of PNGs

% Depth datasets
cd data

% Make3D
% sourceDataFolder = 'Make3D/';
% sourceImgFolders = strcat(sourceDataFolder,{'Train400Img/','Test134/'});
% sourceDepthFolders = strcat(sourceDataFolder,{'Train400Depth/','Gridlaserdata/'});
% destImgFolders = {'Make3D-train-img/','Make3D-test-img/'};
% destDepthFolders = {'Make3D-train-depth/','Make3D-test-depth/'};
% for i = 1:2
%     if ~exist(destImgFolders{i},'file') || ~exist(destDepthFolders{i},'file')
%         dirFiles = dir([sourceImgFolders{i} '*.jpg']);
%         imgFiles = strcat(sourceImgFolders{i},{dirFiles.name}');
%         dirFiles = dir([sourceDepthFolders{i} '*.mat']);
%         depthFiles = strcat(sourceDepthFolders{i},{dirFiles.name}');
%         nFiles = length(imgFiles);
%         if nFiles ~= length(depthFiles) % basic error checking
%             error('Unbalanced image and depth data');
%         end
%         mkdir(destImgFolders{i});
%         mkdir(destDepthFolders{i});
%         for j = 1:nFiles
%             filename = num2str(j-1,'%04d.png');
%             imageData = imread(imgFiles{j});
%             imwrite(imageData,[destImgFolders{i} filename]);
%             load(depthFiles{j});
%             depthMap = Position3DGrid(:,:,4);
%             minDepth = 0.9200; maxDepth = 81.9214;
%             depthMap = (depthMap-minDepth)/(maxDepth-minDepth);
%             imwrite(depthMap,[destDepthFolders{i} filename]);
%         end
%     end
% end
% 
% % NYU Depth V2
% trainPortion = 0.7; % portion allocated to the training set
% destImgFolders = {'NYU-train-img/','NYU-test-img/'};
% destDepthFolders = {'NYU-train-depth/','NYU-test-depth/'};
% if ~exist(destImgFolders{1},'file') || ~exist(destDepthFolders{1},'file') || ...
%    ~exist(destImgFolders{2},'file') || ~exist(destDepthFolders{2},'file')
%     mkdir(destImgFolders{1}); mkdir(destDepthFolders{1});
%     mkdir(destImgFolders{2}); mkdir(destDepthFolders{2});
%     load('NYUDepthV2/nyu_depth_v2_labeled.mat');
%     nFiles = size(images,4);
%     n = [0 0];
%     for i = 1:nFiles
%         j = 1+(rand() > trainPortion); % 1 for training, 2 for test
%         n(j) = n(j)+1; % increment corresponding count
%         filename = num2str(n(j)-1,'%04d.png');
%         imwrite(images(:,:,:,i),[destImgFolders{j} filename]);
%         depthMap = depths(:,:,i);
%         minDepth = 0.7133; maxDepth = 9.9955;
%         depthMap = (depthMap-minDepth)/(maxDepth-minDepth);
%         imwrite(depthMap,[destDepthFolders{j} filename]);
%     end
% end

% KITTI 2012
trainPortion = 0.7; % portion allocated to the training set
destImgFolders = {'KITTI2012-train-img/','KITTI2012-test-img/'};
destDispFolders = {'KITTI2012-train-depth/','KITTI2012-test-depth/'};
if ~exist(destImgFolders{1},'file') || ~exist(destDispFolders{1},'file') || ...
   ~exist(destImgFolders{2},'file') || ~exist(destDispFolders{2},'file')
    sourceDataFolder = 'KITTI2012/training/';
    sourceImgFolder = [sourceDataFolder 'colored_0/']; % left camera images
    sourceDispFolder = [sourceDataFolder 'disp_occ/'];
    dirFiles = dir([sourceImgFolder '*0.png']); % only the first of the image pairs
    imgFiles = strcat(sourceImgFolder,{dirFiles.name}');
    dirFiles = dir([sourceDispFolder '*.png']);
    dispFiles = strcat(sourceDispFolder,{dirFiles.name}');
    nFiles = length(imgFiles);
    if nFiles ~= length(dispFiles) % basic error checking
        error('Unbalanced image and depth data');
    end
    mkdir(destImgFolders{1}); mkdir(destDispFolders{1});
    mkdir(destImgFolders{2}); mkdir(destDispFolders{2});
    n = [0 0];
    for i = 1:nFiles
        j = 1+(rand() > trainPortion); % 1 for training, 2 for test
        n(j) = n(j)+1; % increment corresponding count
        filename = num2str(n(j)-1,'%04d.png');
        copyfile(imgFiles{i},[destImgFolders{j} filename]);
        dispData = imread(dispFiles{i});
%         convert to 8 bit png
        imwrite(dispData,[destDispFolders{j} filename],'BitDepth',8);
    end
end

% KITTI 2015
trainPortion = 0.7; % portion allocated to the training set
destImgFolders = {'KITTI2015-train-img/','KITTI2015-test-img/'};
destDispFolders = {'KITTI2015-train-depth/','KITTI2015-test-depth/'};
if ~exist(destImgFolders{1},'file') || ~exist(destDispFolders{1},'file') || ...
   ~exist(destImgFolders{2},'file') || ~exist(destDispFolders{2},'file')
    sourceDataFolder = 'KITTI2015/training/';
    sourceImgFolder = [sourceDataFolder 'image_2/']; % left camera images
    sourceDispFolder = [sourceDataFolder 'disp_occ_0/'];
    dirFiles = dir([sourceImgFolder '*0.png']); % only the first of the image pairs
    imgFiles = strcat(sourceImgFolder,{dirFiles.name}');
    dirFiles = dir([sourceDispFolder '*.png']);
    dispFiles = strcat(sourceDispFolder,{dirFiles.name}');
    nFiles = length(imgFiles);
    if nFiles ~= length(dispFiles) % basic error checking
        error('Unbalanced image and depth data');
    end
    mkdir(destImgFolders{1}); mkdir(destDispFolders{1});
    mkdir(destImgFolders{2}); mkdir(destDispFolders{2});
    n = [0 0];
    for i = 1:nFiles
        j = 1+(rand() > trainPortion); % 1 for training, 2 for test
        n(j) = n(j)+1; % increment corresponding count
        filename = num2str(n(j)-1,'%04d.png');
        copyfile(imgFiles{i},[destImgFolders{j} filename]);
        dispData = imread(dispFiles{i});
%         convert to 8 bit png
        imwrite(dispData,[destDispFolders{j} filename],'BitDepth',8);
    end
end

cd ..;
clear;
