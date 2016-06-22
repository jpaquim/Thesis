% Splits the stereo side-by-side images in imgFolders/img into individual
% left and right images in imgFolders/{imgL,imgR}

folderPrefix = 'data/ZED-';
imgFolders = strcat(folderPrefix, {'03-full/'});
for j = 1:length(imgFolders)
    imgFolder = imgFolders{j};
    srcImgFolder = [imgFolder 'img/'];
    dirFiles = dir([srcImgFolder '*.png']);
    imgFiles = strcat(srcImgFolder,{dirFiles.name}');
    nFiles = length(imgFiles);
    imgFolderL = [imgFolder 'imgL/'];
    imgFolderR = [imgFolder 'imgR/'];
    mkdir(imgFolderL);
    mkdir(imgFolderR);
    for i = 1:nFiles
        display(i);
        filename = imgFiles{i};
        [~,basename] = fileparts(filename);
        img = imread(filename);
        imgWidth = size(img,2)/2;
        imgL = img(:,1:imgWidth,:);
        imgR = img(:,imgWidth+1:end,:);
        imwrite(imgL, [imgFolderL basename '.png']);
        imwrite(imgR, [imgFolderR basename '.png']);
    end
end
