function [concLines]=concatAllLines(c_lines, lineWidthInPixel)
    coder.varsize('concLinestemp',150,0);
    concLinestemp = cell(150,1);
    for idx1 = 1:150
        concLines={};
        concLinestemp{idx1} = 0;
    end
    q=1;
    startSearchIdx = find([c_lines{5,1,:}]==0,1,'First');
    if isempty(startSearchIdx)
        return
    else
        while(sum([c_lines{5,1,:}]==0,2))
            startSearchIdx = find([c_lines{5,1,:}]==0,1,'First');
            startSearchIdx = startSearchIdx(1);
            c_lines{5,1,startSearchIdx} = 1;
            vectorSize = 0;
            static_a =[c_lines{1,1,startSearchIdx}, c_lines{3,1,startSearchIdx};c_lines{2,1,startSearchIdx}, c_lines{3,1,startSearchIdx}];
            coder.varsize('a');
            a = static_a;
            while(size(a,1)~=vectorSize)
                vectorSize = size(a,1);
                maxDistance = lineWidthInPixel*0.8;
                [a,c_lines] = concatlines(c_lines,startSearchIdx,c_lines{1,1,startSearchIdx},a,maxDistance);
                [a,c_lines] = concatlines(c_lines,startSearchIdx,c_lines{2,1,startSearchIdx},a,maxDistance);
            end
        %     l1=a
            concLinestemp{q} = a;
            q=q+1;
        end    
    end
    
    concLinesLength = q-1;
    concLines = cell(1,concLinesLength);
    for idx1 = 1:concLinesLength
        concLines{idx1} = concLinestemp{idx1};
    end
end