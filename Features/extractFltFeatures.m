function fltFeatures = extractFltFeatures(imgYCbCr,filters,channels,cfg)
%EXTRACTFLTFEATURES Summary of this function goes here
%   Detailed explanation goes here
nFilters = length(channels); % number of filters applied
nFltFeatures = 2*cfg.nScales*length(channels);
fltFeatures = zeros(cfg.nPatches,nFltFeatures);
fltFeatures2 = zeros(cfg.nPatches,nFltFeatures);
for flt = 1:nFilters
%     apply the filters to the corresponding image channels
    imgFilt = imfilter(imgYCbCr(:,:,channels(flt)),filters{flt},...
        'symmetric','conv');
    ABS_IF = getIntegralImage(abs(imgFilt));
    SQ_IF = getIntegralImage(imgFilt.^2);
    for scl = 1:cfg.nScales
        for ptc = 1:cfg.stepSize:cfg.nPatches
            % imgPatch = imgFilt(cfg.ptcRows{scl}(:,ptc),...
            %                    cfg.ptcCols{scl}(:,ptc));
            feat = 2*(scl+(flt-1)*cfg.nScales);
            % calculate the energies for each patch
            % fltFeatures2(ptc,feat-1) = sum(abs(imgPatch(:)));
            fltFeatures(ptc,feat-1) = getSumIntegralImage(ABS_IF, [cfg.ptcRows{scl}(1,ptc), cfg.ptcRows{scl}(end,ptc)], [cfg.ptcCols{scl}(1,ptc), cfg.ptcCols{scl}(end,ptc)]);
            % fltFeatures2(ptc,feat) = sum(imgPatch(:).^2);
            fltFeatures(ptc,feat) = getSumIntegralImage(SQ_IF, [cfg.ptcRows{scl}(1,ptc), cfg.ptcRows{scl}(end,ptc)], [cfg.ptcCols{scl}(1,ptc), cfg.ptcCols{scl}(end,ptc)]);
        end
    end
end

% difference = mean(abs(fltFeatures(:) - fltFeatures2(:)));
% fprintf('Absolute difference slow and fast method on average: %f\n', difference);

end