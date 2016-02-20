function textons = loadDictionary(type)
%LOADDICTIONARY Summary of this function goes here
%   Detailed explanation goes here

if strcmp(type,'gray')
    fileName = 'grayDictionary.mat';
elseif strcmp(type,'color')
    fileName = 'colorDictionary.mat';
end

if exist(fileName,'file')
%     if the file exists, load the data directly from it
    load(fileName);
else
%     if the file doesn't exist, regenerate the data file
    textons = generateDictionary(type);
    save(fileName,'textons');
end
end