%author: Long Le
function [ETrain, XTrain, YTrain] = BuildTrain2(idFile, roleFile, roleOrFeat, fileList, selectList, scoreOrDrop, nTrains)
    funs = ReadData;
    XTrain = [];
    YTrain = [];
    ETrain = [];
    %scoreOrDrop = 1; %0 is eigenScore and 1 is eigenvalue drop 
    %roleOrFeat = 1; % 0 is reading the roles, 1 is reading the features
    %fprintf('Select Melt %i\n', selectMelt)
    
    id = funs.readID(idFile);
    
    if (roleOrFeat == 0)
        %role = funs.readRole(roleFile, nRoles);
        role = load(roleFile);
    else
        role = dlmread(roleFile, ',', 0, 1);
    end
    
    [~, index] = sort(id);
    roleOrder = role(index,:);
    
    [~, nItem] =size(selectList);
    for i = 1:nItem
        %Read contain if the select = true
        select = selectList(i);
        if (select == 1)
            fprintf('%s', fileList{i});
            [src, dst, eigenScore, eigenDrop] = funs.readEdges(fileList{i});
            X = [roleOrder(src,:), roleOrder(dst,:)];
            if scoreOrDrop == 0
                Y = eigenScore;
            else
                Y = (-1) * eigenDrop;
            end
            XTrain = [XTrain; X(1:nTrains, :)];
            YTrain = [YTrain; Y(1:nTrains, :)];
            ETrain = [ETrain; [src(1:nTrains, :), dst(1:nTrains, :)]];
        end
    end
end
