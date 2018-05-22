%author: Long Le
%Give a graph, we random pick some edges and calculate eigenScore,
%eigenValue drop, etc

clear;

dataDir = '../data/network/';


k =1000;
k0 = 1;
flag = 0; %0 is undirected
recompute = 1;
addOrDel = 0 ; %0 is del, 1 is add


outputDir = '../data/eigenvalue-recompute/';


for i = [1, 2]
    fprintf ('Network %i\n', i);
    edges = csvread(strcat(dataDir, int2str(i), '.csv'));
    
    A  = sparse(edges(:,1), edges(:,2), edges(:,3));
    
    %Pick up random edges
    T = IE_RAND_k(A,k,flag);
    
    %Calculate eigenScore, eigenValue drop
    [eigenScore, eigenGap] =  IE_DeltaLam_GivenT(A, T, k0, flag, addOrDel);
    
    if (recompute ==1)
        outputName = strcat(outputDir, int2str(i), '_del_', int2str(k), '_recompute_random', '.csv');
    else
        outputName = strcat(outputDir, int2str(i), '_del_', int2str(k), '_random.csv');
    end
    
    fl = fopen(outputName, 'w+');
    fprintf(fl, 'src, dst, eigenScore, eigenValueDrop,lambda1, lambda2, lambda3, lambda4, lambda5, lambda6, nlambda1, nlambda2,nlambda3,lambda4, nlambda5, nlambda6\n' );
    fclose(fl);
    dlmwrite(outputName, [T eigenScore eigenGap], '-append', 'delimiter', ',');
end
