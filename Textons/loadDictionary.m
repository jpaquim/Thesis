function textons = loadDictionary(t)
%LOADDICTIONARY Summary of this function goes here
%   Detailed explanation goes here

if t.color
    fileName = 'colorDictionary.mat';
else
    fileName = 'grayDictionary.mat';
end
if exist(fileName,'file') % if the data file already exists
    fileVars = load(fileName,'t');
    if isequal(fileVars.t,t) % and if t is as desired
        load(fileName); % load the data directly from it
        return;
    end
end
% if the file doesn't exist, or t has changed, regenerate the data file
textons = generateDictionary(t);
save(fileName,'textons','t');
end