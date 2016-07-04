function depthsFilt = filterDepths(depths,mapSize,filterType)
%FILTERDEPTHS Filters depth data according to the specified filter
%   depthsFilt = FILTERDEPTHS(depths,mapSize,filterType)
%   Applies the filter given in filterType, which can be either 'median' or
%   'gaussian' to the depth data given in the depths vector, where the actual
%   depth maps are sized mapSize(1) by mapSize(2).

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
