function disps = computeDisparity(imgL,imgR)
%COMPUTEDISPARITY Summary of this function goes here
%   Detailed explanation goes here

method = 0;
switch method
    case 0
        imgL = rgb2gray(imgL);
        imgR = rgb2gray(imgR);
        disps = disparity(imgL,imgR,'BlockSize',21);
        disps(disps < 0) = -1; % unreliably estimated disparities
    case 1
        disps = run_SparseStereo_one_sided(imgL,imgR,imgWidth);
    case 2
        disps = StereoDisp(imgL,imgR);%,K,max_disp,win_size,disp_scale);
    case 3
        disps = stereomatch(imgL,imgR,windowsize,disparity,spacc);
    otherwise
        error(['Unknown method' method]);
end
