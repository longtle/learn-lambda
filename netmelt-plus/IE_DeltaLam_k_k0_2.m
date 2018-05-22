function [TOutput, eigenScore, eigenGap] =  IE_DeltaLam_k_k0_2(A,k, k0, flag, recompute)

% We only compute the largest eigenvalue (another function compute all 6
% leading eigenvalues)
%%%%find k edges, whose deletion creates largest drop in lambda
%%%%by 1st order perturbation
% This is different that we recompute the leading eigenvalue after every k0
% steps
% recompute = 1: recompute eigenscore after some steps
% recompute = 0: compute eigenscore ounce only

if max(max(A)) ==1
    un=1;
else
    un = 0;
end
T = zeros(k, 2);
eigenScore = zeros(k, 1); %To store eigenScore
eigenGap = zeros(k, 13); %To store the eigenGap

lambda = eigs(A);
if flag==1%directed graph
    [a,b,c] = find(A);
    [u,~] = eigs(A,1,'lm');%%%right eigen value
    u = abs(u);
    [v,~] = eigs(A',1,'lm');%left eigen values
    v = abs(v);
    if un==1
        d = full(v(a).*u(b));
    else
        d = full(v(a).*u(b).*c);
    end
    
    for j = 1:(k/k0)
        if recompute==1 
            fprintf ('Recompute eigen-score %i\n', j);
            [a,b,c] = find(A);
            [u,~] = eigs(A,1,'lm');%%%right eigen value
            u = abs(u);
            [v,~] = eigs(A',1,'lm');%left eigen values
            v = abs(v);
            if un==1
                d = full(v(a).*u(b));
            else
                d = full(v(a).*u(b).*c);
            end
        end
        
       
        E = zeros(k0,1);
        for i=1:k0 %if we add reverse, use i=1:k0/2
            maxScore = max(d);
            e0 = find(d==maxScore);
            e0 = e0(1);
            E(i) = e0;
            d(e0) = -1;
            
            %Long's edit: add reverse edges to make consistant if
            %We are sure that score e(i,j) = score(j, i)
            %e1 = find((a== b(e0)) & (b == a(e0))); %The reverse
            %E(2*i) = e0;
            %d(e1) = -1;
            
            %Set the delete edge to 0
            A(a(e0), b(e0)) = 0;
            %A(a(e1), b(e1)) = 0;
            
            eigenScore((j-1) * k0 + i,:) = maxScore;
        end
        %Compute eigensValue change
        newLambda = eigs(A);
        lambdaChange = [abs(newLambda(1)) - abs(lambda(1)), lambda', newLambda'];
        startIndex = (j - 1) * k0 + 1;
        endIndex = j * k0;
        eigenGap(startIndex:endIndex, :) = repmat(lambdaChange, k0, 1);
        lambda = newLambda;
        
        E = [a(E),b(E)];
        T(startIndex:endIndex, :) = E;
       
    end
    TOutput = T;
    
else %%undirected graph
    
    %tic;
    %%%right eigen value
    fprintf ('Undirected graph\n');
    [u,lambda] = eigs(A,1,'lm');
    u = abs(u);
    [a,b,c] = find(triu(A,1)); %upper diag mat
    
    if un==1
        d = full(u(a).*u(b));
    else
        d = full(u(a).*u(b).*c * 2);
    end

    for j = 1:(k/k0)
        fprintf ('Round %i\n', j);
        if recompute==1 
            %tic
            fprintf ('Recompute eigen-score %i\n', j);
            [u, lambda] = eigs(A,1,'lm');
            u = abs(u);
            [a,b,c] = find(triu(A,1));
            if un==1
                d = full(u(a).*u(b));
            else
                d = full(u(a).*u(b).*c * 2);
            end
            %toc
        end
      
        E = zeros(k0,1);
        for i=1:k0
            maxScore = max(d);
            e0 = find(d==maxScore);
            e0 = e0(1);
            E(i) = e0;
            d(e0) = -1;
         
            %Set the deleted edge to matrix
            A(a(e0), b(e0)) = 0;
            A(b(e0), a(e0)) = 0; %A[i,j] = A[j,i] =0
            eigenScore((j-1) * k0 + i,:) = maxScore;
            
        end
        %Compute eigensValue change
        [~, newLambda] = eigs(A, 1, 'lm');
        lambdaChange = [abs(newLambda) - abs(lambda), lambda, 0, 0, 0, 0, 0, newLambda, 0 , 0, 0, 0, 0];
        startIndex = (j - 1) * k0 + 1;
        endIndex = j * k0;
        eigenGap(startIndex:endIndex, :) = repmat(lambdaChange, k0, 1);
        lambda = newLambda;
        
        E = [a(E),b(E)];
        T(startIndex:endIndex, :) = E;
       
    end
    TOutput = T;
end
%disp(T)
