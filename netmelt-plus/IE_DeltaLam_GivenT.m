function [eigenScore, eigenGap] =  IE_DeltaLam_GivenT(A, T , k0, flag, addOrDel)

%Given list of edges T, we want compute the leading eigenvalue drop
%This method is different from IE_DeltaLam_k_k0 since we don't find list T,
%but given T, we want to calculate eigen drop
%flag==1 : directed graph
%addOrDel: 0 is del, 1 is add

[k, ~] = size(T);
eigenGap = zeros(k, 13); %To store the eigenGap
eigenScore = zeros(k, 1); % To store eigenScore

lamda = eigs(A);
recompute=1;

if max(max(A)) ==1
    un=1;
else
    un = 0;
end
 
%Compute eigenscore at beginning:
[u,~] = eigs(A,1,'lm');
u = abs(u);
[a,b,c] = find(triu(A,1));
if un==1
    d = full(u(a).*u(b));
else
    d = full(u(a).*u(b).*c);
end

for j = 1:(k/k0)
    if recompute==1 
        tic
       
        %fprintf ('Recompute %i\n', j);
        
        %Compute eigenscore:
        [u,~] = eigs(A,1,'lm');
        u = abs(u);
        [a,b,c] = find(triu(A,1));
        if un==1
            d = full(u(a).*u(b));
        else
            d = full(u(a).*u(b).*c);
        end
    end
            
    for i=1:k0
        idx = (j - 1) * k0 + i;
        e = T(idx, :);
        
        scoreIdx = find((a== min(e)) & (b == max(e))); %We use triu, so we want to make sure src < dst index
        eigenScore(idx, :) = d(scoreIdx);
        %Set the deleted edge to matrix
        A(e(1), e(2)) = addOrDel;
        if (flag ==0)
            A(e(2), e(1)) = addOrDel; %A[i,j] = A[j,i] =0
        end
    end
    %Compute eigensValue change
    newLamda = eigs(A);
    lamdaChange = [abs(newLamda(1)) - abs(lamda(1)), lamda', newLamda'];
    startIndex = (j - 1) * k0 + 1;
    endIndex = j * k0;
    eigenGap(startIndex:endIndex, :) = repmat(lamdaChange, k0, 1);
    lamda = newLamda;
    
end

%disp(T)
