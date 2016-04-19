function [imgFiles,depthFiles,indFiles] = ...
    dataFilePaths(dataset,indFiles,shuffle)
%DATAFILEPATHS Summary of this function goes here
%   Detailed explanation goes here

folderPrefix = './data/';

imgFolder = [folderPrefix dataset 'Img/'];
depthFolder = [folderPrefix dataset 'Depth/'];

dirFiles = dir([imgFolder '*.png']);
imgFiles = strcat(imgFolder,{dirFiles.name}');
dirFiles = dir([depthFolder '*.mat']);
depthFiles = strcat(depthFolder,{dirFiles.name}');
nFiles = length(imgFiles);
if nFiles ~= length(depthFiles) % basic error checking
    error('Unbalanced image and depth data');
end

if exist('indFiles','var') % returns only some files
    if exist('shuffle','var') && shuffle
        if isscalar(indFiles) % treat it as the number of files requested
            nFilesReq = indFiles; % selected at random
            indFiles = randperm(nFiles,nFilesReq);
        elseif strcmp(indFiles,'all') % returns the full file list shuffled
            indFiles = randperm(nFiles);
        else % permute the elements of ind at random
            indFiles = indFiles(randperm(length(indFiles)));
        end
    end
    imgFiles = imgFiles(indFiles);
    depthFiles = depthFiles(indFiles);
    if isscalar(indFiles) % return string instead of one element cell
        imgFiles = imgFiles{1};
        depthFiles = depthFiles{1};
    end
end
end
