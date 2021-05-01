function [result] = absTol(list, absTol)
    coder.varsize('result')
    uniqueVal = sort(unique(list));
    result = [];
    structIdx = 1;
    c=0;
    if(size(uniqueVal)>0)
        c=uniqueVal(1);
    end
    for i=2:size(uniqueVal,1)
        if(abs(uniqueVal(i)-uniqueVal(i-1))<=absTol)
            c=[c,uniqueVal(i)];
        else
            result=[result;min(c), max(c)];
            structIdx=structIdx+1;
            c=uniqueVal(i);
        end
    end
    result=[result;min(c), max(c)];
end