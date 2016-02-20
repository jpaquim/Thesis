function [imgFiles,depthFiles] = dataFilePaths(type)
%DATAFILEPATHS Summary of this function goes here
%   Detailed explanation goes here

if strcmp(type,'training')
    imgFolder = 'Train400Img/';
    depthFolder = 'Train400Depth/';
elseif strcmp(type,'test')
    imgFolder = 'Test134Img/';
    depthFolder = 'Test134Depth/';
else
    error(['Invalid data type requested: ' type]);
end
folderPrefix = './data/';
imgFolder = [folderPrefix imgFolder];
depthFolder = [folderPrefix depthFolder];

dirFiles = dir([imgFolder '*.jpg']);
imgFiles = strcat(imgFolder,{dirFiles.name}');
dirFiles = dir([depthFolder '*.mat']);
depthFiles = strcat(depthFolder,{dirFiles.name}');
end