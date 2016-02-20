function binData = convertToBinClasses(data,nClasses)
%CONVERTTOBINCLASSES Summary of this function goes here
%   Detailed explanation goes here

binData = zeros(nClasses,size(data,1));
I = eye(nClasses);
for i = 1:nClasses
    ind = find(data == i);
    binData(:,ind) = repmat(I(:,i),1,length(ind));
end
end