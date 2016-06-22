function disps = computeDisparity(imgL,imgR,method)
%COMPUTEDISPARITY Summary of this function goes here
%   Detailed explanation goes here

[imgL,imgR] = rectifyStereoImages(imgL,imgR);

switch method
    case 'Dense'
        disps = disparity(imgL,imgR,'BlockSize',21);
        disps(disps < 0) = -1; % unreliably estimated disparities
%         disps = StereoDisp(imgL,imgR);%,K,max_disp,win_size,disp_scale);
%         disps = stereomatch(imgL,imgR,windowsize,disparity,spacc);
    case 'Sparse'
        disps = sparseDisparity(imgL,imgR);
        disps(disps == 0) = -1;
    otherwise
        error(['Unknown method' method]);
end
