function [eOrdered] =  ReArrange(eList)
%Given an eList, we want to reorder the list
%such that if a-b appear, b-a will appear immediately after
    %disp(eList);
    nEdges = size(eList, 1);
    eOrdered = [];
    inAlr = ones(nEdges, 1);
    count = 0;
    for i = 1: nEdges
        if (inAlr(i) == 1)
            %eList(i, :)
            eOrdered = [eOrdered; eList(i, :)];
            %Add the reverse
            src = eList(i, 1);
            dst = eList(i, 2);
            reverse = [dst, src];
            reverseIdx = ismember(eList, reverse, 'rows');
            reverseIdx = find(reverseIdx);
            eOrdered = [eOrdered; reverse];
            count = count + 2;
            if (reverseIdx > 0)
                inAlr(reverseIdx) = 0;
            end
            if (count > nEdges)
                break
            end
        end
    end
    
end