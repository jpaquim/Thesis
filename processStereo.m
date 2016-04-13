vidObj = VideoReader('data/Stereo/MITCubicle.m4v');

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

imgHeight = vidHeight;
imgWidth = vidWidth/2;

% vidObj.CurrentTime = 2; % start 2 seconds from the beginning of the video

i = 0;
j = 1;
% while hasFrame(vidObj)
while vidObj.CurrentTime <= 4
    cdata = readFrame(vidObj);
    if mod(i,10) == 0 % save one in every five frames
        imgL = cdata(:,1:imgWidth);
        imgR = cdata(:,imgWidth+1:end);
        imgLData(:,:,:,j) = imgL;
        imgRData(:,:,:,j) = imgR;
%         disps(:,:,j) = disparity(imgL,imgR); % MATLAB function
%         disps(:,:,j) = run_SparseStereo_one_sided(imgL,imgR,imgWidth);
        disps(:,:,j) = StereoDisp(imgL,imgR,K,max_disp,win_size,disp_scale);
        disps(:,:,j) = stereomatch(imgL,imgR,windowsize,disparity,spacc);
        j = j+1;
    end
    i = i+1;
end

addpath('Stereo')
