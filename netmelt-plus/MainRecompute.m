%author: Long Le
%Given graph, find the edges selected by NetMelt/NetMetl+

clear;

graphDir = '../data/network/';

k =1000; % # of edges removed
k0 = 1; %How often do we recompute eigenscores
flag = 0; %0 is undirected

outputDir = '../data/eigenvalue-recompute/';

%The list of graph that we want to compute NetMelt/NetMelt+

for i = [1, 2]
    
    fprintf ('Network %i\n', i);
    edges = csvread(strcat(graphDir, int2str(i), '.csv'));
    
    A  = sparse(edges(:,1), edges(:,2), edges(:,3));
    
    for recompute = [0,1] %1 when recompute eigenscore, 0 when compute once at beginning
        tic
        %[X, Y, Z] =  IE_DeltaLam_k_k0_2(A, k, k0, flag, recompute);
        [X, Y, Z] =  IE_DeltaLam_k_k0(A, k, k0, flag, recompute);
        toc
        if (recompute ==1)
            if (k0 ~= 1)
                outputName = strcat(outputDir, int2str(i), '_del_', int2str(k), '_', int2str(k0), '_recompute', '.csv');
            else
                outputName = strcat(outputDir, int2str(i), '_del_', int2str(k), '_recompute', '.csv');
            end
        else
            %outputName = strcat(outputDir, int2str(i), '_del_', int2str(k), '_', int2str(k0), '.csv');
            outputName = strcat(outputDir, int2str(i), '_del_', int2str(k), '.csv');
        end
        
        fl = fopen(outputName, 'w+');
        %To reduce the computation cost, set lambda2 - lambda6 equals to 0. we
        %can call IE_DeltaLam_k_k0 to calculate these values
        fprintf(fl, 'src, dst, eigenScore, eigenValueDrop,lambda1, lambda2, lambda3, lambda4, lambda5, lambda6, nlambda1, nlambda2,nlamdba3,lambda4, nlambda5, nlambda6\n' );
        fclose(fl);
        dlmwrite(outputName, [X Y Z], '-append', 'delimiter', ',');
    end
end
