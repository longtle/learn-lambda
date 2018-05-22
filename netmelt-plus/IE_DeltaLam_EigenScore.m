function [srcList, dstList, eigenScore] =  IE_DeltaLam_EigenScore(A)

%Given a graph, we extract the eigenscore of each edge
%X: list of source, Y: list of dst
if max(max(A)) ==1
    un=1;
else
    un = 0;
end
if flag==1%directed graph
    
    [a,b,c] = find(A);
    
    [u,~] = eigs(A,1,'lm');
    u = abs(u);
    %toc;
    %%%left eigen values
    [v,~] = eigs(A',1,'lm');
    v = abs(v);
    %toc;
    if un==1
        d = full(v(a).*u(b));
    else
        d = full(v(a).*u(b).*c);
    end
    srcList = a;
    dstList = b;
    eigenScore = d;
else %%undirected graph
    
    %tic;
    %%%right eigen value
    [u,~] = eigs(A,1,'lm');
    u = abs(u);
    %toc;
    [a,b,c] = find(triu(A,1));
    %toc;
    if un==1
        d = full(u(a).*u(b));
    else
        d = full(u(a).*u(b).*c * 2);
    end

    srcList = a;
    dstList = b;
    eigenScore = d;
end
%disp(T)
