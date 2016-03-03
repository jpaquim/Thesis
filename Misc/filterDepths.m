function depthsFilt = filterDepths(depths,mapSize,filterType)
%FILTERDEPTHS Summary of this function goes here
%   Detailed explanation goes here

depthsStack = patchesToImages(depths,mapSize);
depthsFilt = zeros(size(depthsStack));
switch filterType
    case 'median'
        for i = 1:size(depthsStack,3);
            depthsFilt(:,:,i) = medfilt2(depthsStack(:,:,i),'symmetric');
        end
    case 'gaussian'
        hSize = 10;
        sigma = 1;
        depthsFilt = imfilter(depthsStack,...
            fspecial('gaussian',hSize,sigma));
end
depthsFilt = depthsFilt(:);
end