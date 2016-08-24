% add the paths of the various modules
addpath Textons
addpath Data-Handling
addpath Features
addpath Classification
addpath Regression
addpath Post-Processing
addpath Optimization

% possible datasets - KITTI2012-train, KITTI2012-test
%                     KITTI2015-train, KITTI2015-test
%                     Make3D-train, Make3D-test
%                     NYUDepthV2-train, NYUDepthV2-test
%                     ZED-01-standard, ZED-01-fill
%                     ZED-02-standard, ZED-02-fill
%                     ...            , ...
%                     ZED-15-standard, ZED-15-fill
trainDataset = 'HEIGHT-train';
testDataset = 'HEIGHT-test';

% load the trained model to make predictions on the test set:
load([trainDataset '-model-train.mat']);

GRAPHICS = true;
WAIT = false;

% structure that contains the configuration of the image, patches, textons
cfg = defaultConfig(trainDataset);

% get all file names:
[imgFiles,depthFiles,fileNumbers] = dataFilePaths(testDataset,'all', true);

% precompute auxiliary variables needed afterwards, and update cfg
% we now do it here to get the depths at the right positions
cfg = computeAuxVars(cfg);

meanDepths= zeros(length(depthFiles), 1);
medianDepths= zeros(length(depthFiles), 1);
Depths = zeros(length(depthFiles), 1);
for i = 1:length(depthFiles)
    
    fprintf('Image %d / %d\n', i, length(depthFiles));
    
    % get depths and features:
    depths = generateDepthsData(depthFiles(i),cfg);
    Depths(i) = mean(depths);
    features = generateFeaturesData(imgFiles(i),cfg);
    % normalize the training features to the [0 1] range
    features = normalizeFeatures(features,offset,scale);
    % add a bias:
    features = [features ones(size(features,1),1)];
    % predict depths:
    predictions = predictCLS(features, model);
    medianDepths(i) = median(predictions);
    meanDepths(i) = mean(predictions);
    
    fprintf('Depth = %f, median pred = %f, mean pred = %f\n',  Depths(i),  medianDepths(i),  meanDepths(i));
    
    if(GRAPHICS && cfg.stepSize == 1)
        % show the image and depth image:
        Im = imread(imgFiles{i});
        if(exist('h', 'var'))
            close(h);
        end
        h = figure();
        subplot(1,2,1); imshow(Im); title('Image');
        subplot(1,2,2);
        DIm = reshape(predictions, [cfg.nRows, cfg.nCols]);
        imagesc(DIm); caxis([cfg.minRange, cfg.maxRange]);
        colorbar
        title(['Depths - avg = ' num2str(meanDepths(i)) ' GT = ' num2str(Depths(i))]);
        if(WAIT)
            waitforbuttonpress();
        else
            pause(0.1);
        end
    end
    
end

% get the performance metrics:
    [logError,relativeAbsoluteError,relativeSquareError,...
        rmsLinearError,rmsLogError,scaleInvariantError] = ...
        performanceMetrics(meanDepths,Depths,dataset);

% plot depths per image:
h2 = figure();
plot(1:length(depthFiles), Depths);
hold on;
plot(1:length(depthFiles), meanDepths);
plot(1:length(depthFiles), medianDepths);
legend('GT depths', 'Mean predictions', 'Median predictions');

