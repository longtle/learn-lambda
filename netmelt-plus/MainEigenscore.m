%author: Long Le
% Given graph, we want to compute eigenscore of all edges at beginning
clear;

dataDir = '../data/network/';

flag = 0; %0 is undirected

outputDir = '../data/eigenvalue-recompute/';

for i = [1, 2]
    tic
    fprintf ('Network %i\n', i);
    edges = csvread(strcat(dataDir, int2str(i), '.csv'));
    
    A  = sparse(edges(:,1), edges(:,2), edges(:,3));
    outputName = strcat(outputDir, int2str(i), '_eigenScore', '.csv')
    
    [X, Y, Z] = IE_DeltaLam_EigenScore(A);
    
    fl = fopen(outputName, 'w+');
    fprintf(fl, 'src, dst, eigenScore\n' );
    fclose(fl);
    dlmwrite(outputName, [X Y Z], '-append', 'delimiter', ',');
    toc
end
