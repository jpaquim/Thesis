% processes stereo videos

cd data

imgFolderL = 'CubicleImgL/';
imgFolderR = 'CubicleImgR/';
if ~exist(imgFolderL,'file') || ~exist(imgFolderR,'file')
    vidObj = VideoReader('Stereo/MITCubicle.m4v');
    vidHeight = vidObj.Height;
    vidWidth = vidObj.Width;
    imgHeight = vidHeight;
    imgWidth = vidWidth/2;
    i = 0;
    j = 1;
    mkdir(imgFolderL)
    mkdir(imgFolderR)
    while hasFrame(vidObj)
        cdata = readFrame(vidObj);
        if mod(i,10) == 0 % save one in every 10 frames
            imgL = cdata(:,1:imgWidth,:);
            imgR = cdata(:,imgWidth+1:end,:);
            filename = num2str(j,'%04d');
            imwrite(imgL,[imgFolderL filename '.png']);
            imwrite(imgR,[imgFolderR filename '.png']);
            j = j+1;
        end
        i = i+1;
    end
end
addpath ../Stereo-Matching
trainFolder = 'CubicleTrainDepth/';
testFolder = 'CubicleTestDepth/';
if ~exist(trainFolder,'file') || ~exist(testFolder,'file')
    dirFilesL = dir([imgFolderL '*.png']);
    imgFilesL = strcat(imgFolderL,{dirFilesL.name}');
    dirFilesR = dir([imgFolderR '*.png']);
    imgFilesR = strcat(imgFolderR,{dirFilesR.name}');
    mkdir(trainFolder);
    mkdir(testFolder);
    nFiles = length(imgFilesL);
    for i = 1:nFiles
        imgL = imread(imgFilesL{i});
        imgR = imread(imgFilesR{i});
        filename = num2str(i,'%04d');
        depth = computeDisparity(imgL,imgR,'Sparse');
        save([trainFolder filename '.mat'],'depth');
        depth = computeDisparity(imgL,imgR,'Dense');
        save([testFolder filename '.mat'],'depth');
%         dispDense = computeDisparity(imgL,imgR,'Dense');
%         dispSparse = computeDisparity(imgL,imgR,'Sparse');
%         save([dispFolder filename '.mat'],'dispDense','dispSparse');
    end
end

cd ..
