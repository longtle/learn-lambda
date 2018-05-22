function [T] =  IE_DeltaLam_k(A,k,flag)

%%%%find k edges, whose deletion creates largest drop in lambda
%%%%by 1st order perturbation

if max(max(A)) ==1
    un=1;
else
    un = 0;
end
if flag==1%directed graph
    %tic;
    [a,b,c] = find(A);
    %toc;
    %%%right eigen value
    [u,lam] = eigs(A,1,'lm');
    u = abs(u);
    %toc;
    %%%left eigen values
    [v,lam] = eigs(A',1,'lm');
    v = abs(v);
    %toc;
    if un==1
        d = full(v(a).*u(b));
    else
        d = full(v(a).*u(b).*c);
    end
    %toc;
%     [d0,I] = sort(d,1,'descend');
%     k = min(k,length(a));
%     T = [a(I(1:k)),b(I(1:k))];
%       T = [a(1:k),b(1:k)];
    E = [];
    for i=1:k
        e0 = find(d==max(d));
        e0 = e0(1);
        E = [E e0];
        d(e0) = -1;
        %Long's edit: add reverse edges to make consistant 
        %We are sure that score e(i,j) = score(j, i)
        
    end
    T = [a(E),b(E)];
    %toc;
else %%undirected graph
    
    %tic;
    %%%right eigen value
    [u,lam] = eigs(A,1,'lm');
    u = abs(u);
    %toc;
    [a,b,c] = find(triu(A,1));
    %toc;
    if un==1
        d = full(u(a).*u(b));
    else
        d = full(u(a).*u(b).*c * 2);
    end
    %toc;
%     using sorting
%      [d0,I] = sort(d,1,'descend');
%      k = min(k,length(a));
%      T = [a(I(1:k)),b(I(1:k))];

%       T = [a(1:k),b(1:k)];
    E = [];
    for i=1:k
        e0 = find(d==max(d));
        e0 = e0(1);
        E = [E e0];
        d(e0) = -1;
    end
    T = [a(E),b(E)];
    %toc;
end
%disp(T)
