function binData = convertToBinClasses(data,nClasses)
%CONVERTTOBINCLASSES Converts from numeric class descriptions to binary vectors
%   Converts data from numeric 1-nClasses class descriptions to
%   binary, length nClasses vectors, preserving vector orientation.
%   [1;3;5], if nClasses = 6, is converted into [1 0 0 0 0 0;
%                                                0 0 1 0 0 0;
%                                                0 0 0 0 1 0].
%   [2 4 3], if nClasses = 5, is converted into [0 0 0;
%                                                1 0 0;
%                                                0 0 1;
%                                                0 1 0;
%                                                0 0 0].

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
