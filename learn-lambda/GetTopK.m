function [topK, index] =  GetTopK(T, k, flag)

%flag = 0: undirected
%flag =1: directed
% Suppose list of edges T is sored in descending order, we want to pick up
% topK but if we pick a-b, we don't want to pick b-a again (if flag = 0)
% T is list of edges with (src dst)

%k = 20
index = zeros(k, 1);
topK = zeros(k, 2);
%nEdges = size(eList, 1);
%inAlr = ones(nEdges, 1);

if flag==1%directed graph
    for i = 1:k
        index(i,:) = i;
    end
else %%undirected graph
    i = 1;
    j = 1;
    while (i <= k) 
        e = T(j,:);
        src = e(1);
        dst = e(2);
        reverse = [dst, src];
        [~, loc1] =  ismember(e, topK, 'rows');
        
        [~, loc2] =  ismember(reverse, topK, 'rows');
       
        if ((loc1 < 1) & (loc2 < 1))
            index(i, :) = j;
            topK(i, :) = e;
            i = i + 1;
            %fprintf ('i %i\n', i);
        end
        j = j + 1;
    end
    fprintf ('j %i\n', j);
end
%disp(T)
