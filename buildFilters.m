function [filters,channels] = buildFilters()
%BUILDFILTERS Summary of this function goes here
%   Detailed explanation goes here

% Laws' masks (3x3, from Davies)
L3 = [1 2 1];
E3 = [-1 0 1];
S3 = [-1 2 -1];
filtLaws = cell(1,9);
filtLaws{1} = L3'*L3;
filtLaws{2} = L3'*E3;
filtLaws{3} = L3'*S3;
filtLaws{4} = E3'*L3;
filtLaws{5} = E3'*E3;
filtLaws{6} = E3'*S3;
filtLaws{7} = S3'*L3;
filtLaws{8} = S3'*E3;
filtLaws{9} = S3'*S3;
% applied to intensity channel to capture texture energy
channels(1:9) = 1;

% Local averaging filters (equal to first Laws' filter)
filtAvg = filtLaws(1);
% applied to color channels to capture haze
channels(10) = 2;
channels(11) = 3;

% Oriented edge filters, ad-hoc solution
% dimFilt = 5; offset = 2; % dimension of filter stencil
% dimAux = dimFilt+offset;
% midElem = (dimAux+1)/2;
% filtAux = ones(dimAux);
% filtAux(:,1:(midElem-1)) = -1;
% filtAux(:,midElem) = 0;
% rotateAndCrop = @(mask,deg) imcrop(imrotate(mask,deg,'bilinear','crop'),...
%                             [1+offset/2 1+offset/2 dimFilt-1 dimFilt-1]);
% filtEdge = cell(1,6);
% for i = 1:6
%     filtEdge{i} = rotateAndCrop(filtAux,(i-1)*30);
% end

% Actual filters used by Saxena et al
% Nevatia-Babu filters oriented edge filters
filtEdge{1} = repmat([-100 -100 0 100 100],5,1);    % 0 deg
filtEdge{2} = [-100 32 100 100 100;                 % 30 deg
               -100 -78 92 100 100;
               -100 -100 0 100 100;
               -100 -100 -92 78 100;
               -100 -100 -100 -32 100];
filtEdge{3} = -filtEdge{2}';                        % 60 deg
filtEdge{4} = -filtEdge{1}';                        % 90 deg
filtEdge{5} = fliplr(filtEdge{3});                  % 120 deg
filtEdge{6} = filtEdge{5}';                         % 150 deg

% applied to intensity to capture texture gradient
channels(12:17) = 1;

filters = [filtLaws,filtAvg,filtAvg,filtEdge];
for i = 1:length(filters)
    normFactor = sum(abs(filters{i}(:)));
    filters{i} = filters{i}/normFactor;
%     imagesc(filters{i}); colormap gray; pause;
end

% TODO: investigate filter and image normalization, same as Saxena?

end