function saveWEKA(cfg, Dataset, Features, Depths)
% function saveWEKA(cfg, Dataset, Features, Depths)

fID = fopen([Dataset '.arff'], 'w');
fprintf(fID, ['%% ' Dataset ' data set\n']);
fprintf(fID, '@relation depth_estimation\n');
% features = [posFeatures fltFeatures HOGFeatures txtFeatures radonFeatures structFeatures];
if cfg.useFeatures(1) 
    fprintf(fID, '@attribute x real\n');    
    fprintf(fID, '@attribute y real\n');    
end
if cfg.useFeatures(2) 
    % cfg.useFilters = ismember(possibleFilters,cfg.filterTypes);
    % cfg.filterDims = [9;2;6];
    % feat = 2*(scl+(flt-1)*cfg.nScales);
    for j = 1:length(cfg.possibleFilters)
        if(cfg.useFilters(j))
            for i = 1:cfg.filterDims(j)
                for s = 1:cfg.nScales
                   fprintf(fID, ['@attribute ' cfg.possibleFilters{j} '_%d_sc%d_abs real\n'], i, s);
                   fprintf(fID, ['@attribute ' cfg.possibleFilters{j} '_%d_sc%d_sqr real\n'], i, s);
                end
            end
        end
    end
end

if cfg.useFeatures(3)
    for b = 1:cfg.nHOGBins
        fprintf(fID, '@attribute HOG_%d real\n', b);
    end
end

if cfg.useFeatures(4)
    for t = 1:cfg.nTextons
        fprintf(fID, '@attribute TEXTONS_%d real\n', t);
    end
end

if(cfg.useFeatures(5))
    for r = 1:2*cfg.nRadonAngles
        fprintf(fID, '@attribute RADON_%d real\n', r);
    end
end

if(cfg.useFeatures(6))
    for s = 1:cfg.nStructBins
        fprintf(fID, '@attribute STRUCTBIN_%d real\n', s);
    end
end
% target values:
fprintf(fID, '@attribute depth real\n');
% the data:
fprintf(fID, '@data\n');
% create WEKA data set:
fprintf('Data set\n');
for s = 1:size(Features, 1)
    if(mod(s, round(size(Features,1)/100)) == 0)
        fprintf('.');
    end
    for f = 1:cfg.nFeatures
        fprintf(fID, '%f, ', Features(s, f));
    end
    fprintf(fID, '%f\n', Depths(s));
end
fclose(fID);