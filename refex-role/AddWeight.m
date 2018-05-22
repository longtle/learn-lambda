%author: Long T. Le
function AddWeight(matFile, outputPrefix)
    %A = importdata(matFile);
    A = importdata('dt_oregon.mat')
    for i=0:8
        fprintf('%i\n', i)
        
        A_k = A.(strcat('A', int2str(i)));
        %[m, n] = size(A_k);
        
        mat_filename = strcat(int2str(i), '_directed', '.csv')
        [a,b,c] = find(A_k);
        [m, n] = size(a) %number of edges
        edgeMat = zeros(m, 3);
        for mIndex = 1: m
            edgeMat(mIndex, 1) = a(mIndex);
            edgeMat(mIndex, 2) = b(mIndex);
            edgeMat(mIndex, 3) = c(mIndex);
        end
        csvwrite(mat_filename, edgeMat);
    end
end