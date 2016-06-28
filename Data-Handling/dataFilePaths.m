function [imgFiles,depthFiles,fileNumbers] = ...
    dataFilePaths(dataset,fileNumbers,shuffle)
%DATAFILEPATHS Retuns lists of the image and depth file paths
%   [imgFiles,depthFiles,fileNumbers] = ...
%       DATAFILEPATHS(dataset,fileNumbers,shuffle)
%   Given the dataset's name, this function will return the paths to the
%   corresponding image and depth files. If fileNumbers is specified as a
%   scalar, and shuffle is true, it will be interpreted as the number of files
%   to return at random. If fileNumbers is a vector, it will be interpreted as
%   the specific files to be returned (in a random order, if shuffle is true).
%   If fileNumbers is the string 'all', every file will be returned (in a random
%   order, if shuffle is true).
%   
%   The outputs imgFiles and depthFiles are either strings or cell arrays of
%   strings, if the number of returned files is > 1.

folderPrefix = './data/';

imgFolder = [folderPrefix dataset '-img/'];
depthFolder = [folderPrefix dataset '-depth/'];

dirFiles = dir([imgFolder '*.png']);
imgFiles = strcat(imgFolder,{dirFiles.name}');
dirFiles = dir([depthFolder '*.png']);
depthFiles = strcat(depthFolder,{dirFiles.name}');
nFiles = length(imgFiles);
if nFiles == 0
    error(['Folder is empty: ' imgFolder]);
end
if nFiles ~= length(depthFiles) % basic error checking
    error('Unbalanced image and depth data');
end

if exist('fileNumbers','var') % returns only some files
    if exist('shuffle','var') && shuffle
        if isscalar(fileNumbers) % treat it as the number of requested
            nFilesReq = fileNumbers; % files instead, selected at random
            fileNumbers = randperm(nFiles,nFilesReq);
        elseif strcmp(fileNumbers,'all') % returns all the files, shuffled
            fileNumbers = randperm(nFiles);
        else % just permute the elements of fileNumbers at random
            fileNumbers = fileNumbers(randperm(length(fileNumbers)));
        end
    end
    imgFiles = imgFiles(fileNumbers);
    depthFiles = depthFiles(fileNumbers);
    if isscalar(fileNumbers) % return string instead of one element cell
        imgFiles = imgFiles{1};
        depthFiles = depthFiles{1};
    end
end
end
