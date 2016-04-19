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
    j = 0;
    mkdir(imgFolderL)
    mkdir(imgFolderR)
    while hasFrame(vidObj)
        cdata = readFrame(vidObj);
        if mod(i,10) == 0 % save one in every 10 frames
            imgL = cdata(:,1:imgWidth,:);
            imgR = cdata(:,imgWidth+1:end,:);
            fileName = num2str(j,'%04d');
            imwrite(imgL,[imgFolderL fileName '.png']);
            imwrite(imgR,[imgFolderR fileName '.png']);
            j = j+1;
        end
        i = i+1;
    end
end
addpath ../StereoMatching
dispFolder = 'CubicleDispDense/';
if ~exist(dispFolder,'file')
    dirFilesL = dir([imgFolderL '*.png']);
    imgFilesL = strcat(imgFolderL,{dirFilesL.name}');
    dirFilesR = dir([imgFolderR '*.png']);
    imgFilesR = strcat(imgFolderR,{dirFilesR.name}');
    mkdir(dispFolder);
    nFiles = length(imgFilesL);
    for i = 1:nFiles
        imgL = imread(imgFilesL{i});
        imgR = imread(imgFilesR{i});
        disps = computeDisparity(imgL,imgR,'Dense');
        disps = computeDisparity(imgL,imgR,'Sparse');
        fileName = num2str(i,'%04d');
        save([dispFolder fileName '.mat'],'disps');
    end
end

cd ..
