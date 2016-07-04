clear all;close all;clc;
  
% get access to the ZED camera
zed = webcam('ZED')
% set the desired resolution
zed.Resolution = zed.AvailableResolutions{1};
% get the image size
[height width channels] = size(snapshot(zed));
  
% Create Figure and wait for keyboard interruption to quit
f = figure('keypressfcn','close','windowstyle','modal');
ok = 1;
% loop over frames
% while ok
N = 60;
datasetL = zeros(height,width/2,channels,N,'uint8');
datasetR = zeros(height,width/2,channels,N,'uint8');
for i = 1:N
    %capture the current image
    img = snapshot(zed);
      
    % split the side by side image into two images
    imgL = img(:,1:width/2,:);
    imgR = img(:,width/2+1:width,:);
    
    datasetL(:,:,:,i) = imgL;
    datasetR(:,:,:,i) = imgR;
    
%     imgL = rgb2gray(imresize(imgL,[400 700]));
%     imgR = rgb2gray(imresize(imgR,[400 700]));
    
    imshow(stereoAnaglyph(imgL,imgR));
    drawnow; % this checks for interrupts
    
    ok = ishandle(f); % does the figure still exist
    pause(1); % wait for a second
end
  
% close the camera instance
clear cam

save('datasetZED.mat','datasetL','datasetR');
