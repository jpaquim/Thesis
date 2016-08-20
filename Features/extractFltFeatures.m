function fltFeatures = extractFltFeatures(imgYCbCr,filters,channels,cfg)
%EXTRACTFLTFEATURES Summary of this function goes here
%   Detailed explanation goes here
nFilters = length(channels); % number of filters applied
nFltFeatures = 2*cfg.nScales*length(channels);
fltFeatures = zeros(cfg.nPatches,nFltFeatures);
for flt = 1:nFilters
%     apply the filters to the corresponding image channels
    imgFilt = imfilter(imgYCbCr(:,:,channels(flt)),filters{flt},...
        'symmetric','conv');
    for scl = 1:cfg.nScales
        for ptc = 1:cfg.nPatches
            imgPatch = imgFilt(cfg.ptcRows{scl}(:,ptc),...
                cfg.ptcCols{scl}(:,ptc));
            feat = 2*(scl+(flt-1)*cfg.nScales);
%             calculate the energies for each patch
% Guido: could be done quicker by calculating abs / .^2 outside of the
% patch loop and using integral images of the results
            fltFeatures(ptc,feat-1) = sum(abs(imgPatch(:)));
            fltFeatures(ptc,feat) = sum(imgPatch(:).^2);
        end
    end
end
end
