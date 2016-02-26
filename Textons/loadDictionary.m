function textons = loadDictionary(cfg)
%LOADDICTIONARY Summary of this function goes here
%   Detailed explanation goes here

if cfg.txtColor
    fileName = 'colorDictionary.mat';
else
    fileName = 'grayDictionary.mat';
end
% if any of these elements change, the dictionary should be regenerated
txtConfig = struct('txtSize',cfg.txtSize,'nTextons',cfg.nTextons,...
                   'nTextures',cfg.nTextures);
if exist(fileName,'file')
    fileVars = load(fileName,'txtConfig');
    if isequal(fileVars.txtConfig,txtConfig)
        load(fileName); % load the data directly from it
        return;
    end
end
% if the file doesn't exist, or txtConfig has changed, regenerate the data
textons = generateDictionary(cfg);
save(fileName,'textons','txtConfig');
end