function textons = loadDictionary(cfg)
%LOADDICTIONARY Summary of this function goes here
%   Detailed explanation goes here

filename = [cfg.dataset 'Dict.mat'];
% if any of these elements change, the dictionary should be regenerated
txtConfig = struct('txtSize',cfg.txtSize,'nTextons',cfg.nTextons,...
                   'nTextures',cfg.nTextures,'txtColor',cfg.txtColor);
if exist(filename,'file')
    fileVars = load(filename,'txtConfig');
    if isequal(fileVars.txtConfig,txtConfig)
        load(filename); % load the data directly from it
        return;
    end
end
% if the file doesn't exist, or txtConfig has changed, regenerate the data
textons = generateDictionary(cfg);
save(filename,'textons','txtConfig');
end
