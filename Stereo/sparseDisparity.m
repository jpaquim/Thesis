function dispMap = sparseDisparity(imgL,imgR)
%SPARSEDISPARITY Summary of this function goes here
%   Detailed explanation goes here

[height,width] = size(imgL);
[~,dispMap] = run_SparseStereo_one_sided(imgL,imgR,width,height-1);

end
