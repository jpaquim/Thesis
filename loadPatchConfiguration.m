function p = loadPatchConfiguration()
%LOADPATCHCONFIGURATION Summary of this function goes here
%   Detailed explanation goes here

if exist('patchConfiguration.mat','file')
%     if the file exists, load the patchConfiguration directly from it
    load patchConfiguration;
else
%     if the file doesn't exist, regenerate the patch configuration file
    p = generatePatchConfiguration([2272 1704],[305 55],[7 7]); % [21 21]);
    save patchConfiguration p;
end
end