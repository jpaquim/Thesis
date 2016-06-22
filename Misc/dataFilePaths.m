function [imgFiles,depthFiles,indFiles] = ...
    dataFilePaths(dataset,indFiles,shuffle)
%DATAFILEPATHS Retuns lists of the image and depth file paths
%   Given the dataset's name, this function will return the paths to the
%   corresponding image and depth files. If indFiles is specified as a scalar,
%   and shuffle is true, it will be interpreted as the number of files to return
%   at random. If indFiles is a vector, it will be interpreted as the specific
%   files to be returned (in a random order, if shuffle is true). If indFiles is
%   the string 'all', every file will be returned (in a random order, if shuffle
%   is true).
%   
%   The outputs imgFiles and depthFiles are strings or cell arrays of strings,
%   indFiles is a vector containing the indices of the returned files, which
%   describe their ordering within the containing folder.

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
