function s = getSumIntegralImage(II, ys, xs)
% function s = getSumIntegralImage(II, ys, xs)
% Gets the sum of an area in an integral image II
% with bounding box [xs(1), ys(1), xs(2), ys(2)]
% the sum includes those coordinates.

% checking boundaries - costs time, so perhaps skip it:
% xs(1) = max([1, xs(1)]);
% xs(2) = min([size(II, 2), xs(2)]);
% ys(1) = max([1, ys(1)]);
% ys(2) = min([size(II, 1), ys(2)]);

% including the coordinates:
xs(1) = xs(1) - 1;
ys(1) = ys(1) - 1;

% calculate sum:
if(xs(1) >= 1 && ys(1) >= 1)
    s = II(ys(2), xs(2)) + II(ys(1), xs(1));
    s = s - II(ys(2), xs(1)) - II(ys(1), xs(2));
elseif(xs(1) < 1 && ys(1) < 1)
    s = II(ys(2), xs(2));
elseif(xs(1) < 1)
    s = II(ys(2), xs(2)) - II(ys(1), xs(2));
else
    s = II(ys(2), xs(2)) - II(ys(2), xs(1));
end