function [T] =  IE_RAND_k(A,k,flag)

%%%%find k edges, by random


if flag==1%directed graph
    [a,b,c] = find(A);
    
    d = rand(length(a),1);
    [d0,I] = sort(d,1,'descend');
    k = min(k,length(a));
    T = [a(I(1:k)),b(I(1:k))];
else %%undirected graph
    
    
    
    [a,b,c] = find(triu(A,1));
    
    d = rand(length(a),1);
    [d0,I] = sort(d,1,'descend');
    k = min(k,length(a));
    T = [a(I(1:k)),b(I(1:k))];
end
