function SimplexProj2(Y)
SimplexProjTwo = @(Y,X,Xtmp) max(bsxfun(@minus,Y,Xtmp(sub2ind(size(Y),(1:size(Y,1))',sum(X>Xtmp,2)))),0);
SimplexProjOne = @(Y,X) SimplexProjTwo(Y,X,bsxfun(@times,cumsum(X,2)-1,(1./(1:size(Y,2)))));
X = SimplexProjOne(Y,sort(Y,2,'descend'));
end
