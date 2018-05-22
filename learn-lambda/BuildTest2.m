%author: Long Le

%We change YTest = 0 since we don't know the ground truth of eigen-drop in testing graph
%(it doesn't matter since the training set and testing set are separate)

function [ETest, XTest, YTest] = BuildTest2(edgeFile, idFile, roleFile, roleOrFeat)
    %edgesFile is eigenScore file
    funs = ReadData;
    %roleOrFeat = 1; % 0 is reading the roles, 1 is reading the features
    
    mat = dlmread(edgeFile, ',', 1, 0);
    srcTest = mat(:,1);
    dstTest = mat(:,2);
    
    idTest = funs.readID(idFile);
    
    %fprintf ('Role file %s\n', roleFile);
    if (roleOrFeat == 0)
        role = load(roleFile); %role = funs.readRole(roleFile, nRoles);
    else
        role = dlmread(roleFile, ',', 0, 1);
    end
    
    [~, indexTest] = sort(idTest);
    roleOrder = role(indexTest,:);
    
    ETest = [srcTest, dstTest];
    XTest = [roleOrder(srcTest,:), roleOrder(dstTest,:)];
    [r, ~] = size(mat);
    YTest = zeros(r, 1); 
end




