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

% structure that contains the configuration of the image, patches, textons
cfg = defaultConfig(trainDataset);
cfg.stepSize = 1; % necessary for showing images

[imgFiles,depthFiles,fileNumbers] = dataFilePaths(testDataset,'all', true);

% precompute auxiliary variables needed afterwards, and update cfg
% we now do it here to get the depths at the right positions
cfg = computeAuxVars(cfg);

h = figure('Name', 'Predicted depths', 'NumberTitle', 'off');
set(gcf, 'Color', [1 1 1]);

for i = 1:length(depthFiles)
    % get depths and features:
    depths = generateDepthsData(depthFiles,cfg);
    features = generateFeaturesData(imgFiles,cfg);
    % normalize the training features to the [0 1] range
    [features,offset,scale] = normalizeFeatures(features);
    % add a bias:
    features = [features ones(size(features,1),1)];
    % predict depths:
    predictions = predictCLS(features, model);
    % get the performance metrics:
    [logError,relativeAbsoluteError,relativeSquareError,...
    rmsLinearError,rmsLogError,scaleInvariantError] = ...
    performanceMetrics(predDepths,depths,dataset);
    % show the image and depth image:
    Im = imread(imFiles{i}); 
    figure(h);
    subplot(1,2,1); imshow(Im); title('Image');
    subplot(1,2,2); 
    DIm = reshape(predDepths, [cfg.nRows, cfg.nCols]);
    imagesc(DIm); title('Depths');
end
