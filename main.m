% add the paths of the various modules
addpath('./Features');
addpath('./Learning');
addpath('./Textons');
addpath('./Misc');

 % read image resolution from the first image in the training set
imgInfo = imfinfo(dataFilePaths('training',1));

% a structure whose fields contain the configuration of the textons
t = textonConfiguration([imgInfo.Height imgInfo.Width],...
                        [5 5],30,10000,false);
% build a structure whose fields contain the configuration of the image and
% patches, including centroid locations.
p = patchConfiguration([55 305],[7 7],3,t);

% load the training data set
[trainFeatures,trainLabels,indFilesTrain] = loadData('training',p,t);
% load the test data set
[testFeatures,testLabels,indFilesTest] = loadData('test',p,t);

% normalize the training features to the [-1 1] range
[trainFeatures,offset,scale] = normalizeFeatures(trainFeatures);
% normalize the test features using the same offset and scale
testFeatures = normalizeFeatures(testFeatures,offset,scale);

% return;

% train the supervised learning model
model = trainModel(trainFeatures,trainLabels,'linear svm');

% accuracy on the training set
predictedTrain = predictModel(...
    trainFeatures,trainLabels,model,'linear svm');
% accuracy on the test set
predictedTest = predictModel(testFeatures,testLabels,model,'linear svm');

% plot confusion matrices for performance on training and test sets
plotConfusionMatrix(trainLabels,predictedTrain);
figure; plotConfusionMatrix(testLabels,predictedTest);

% plot example image, ground truth, labels, and prediction
plotComparison(predictedTrain,indFilesTrain,p,'training');
plotComparison(predictedTest,indFilesTest,p,'test');
