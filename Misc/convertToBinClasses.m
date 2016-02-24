function binData = convertToBinClasses(data,nClasses)
%CONVERTTOBINCLASSES Summary of this function goes here
%   Detailed explanation goes here

binData = zeros(length(data),nClasses);
I = eye(nClasses);
for i = 1:nClasses
    ind = find(data == i);
    binData(ind,:) = repmat(I(i,:),length(ind),1);
end
if isrow(data)
    binData = binData';
end
end