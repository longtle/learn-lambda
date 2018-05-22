function [listEdge] =  PickEdge(edgeFile, predictFile, k)

% Given a edgesFile and the predictedValue (output of weka for example)
% We want pick up the list having highest score

vIndex = 3; 

edgeMat = dlmread(edgeFile, ',', 1, 0);
e = edgeMat (:, 1:2);

predictMat = dlmread(predictFile, ',', 1, 0);
predictValue = predictMat(:,vIndex);
[~, idx] = sort(predictValue, 'descend');
eSorted = e(idx, :);
%listEdge = eSorted(1:k, :);
listEdge= GetTopK(eSorted, k,0);
end
%disp(T)
