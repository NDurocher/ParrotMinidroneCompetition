function [a, c_lines] = concatlines(c_lines,lineidx,point,a,maxDistance)
%   
    for r = 1:size(c_lines,3)
        if r == lineidx
            continue;
        elseif sum(ismember(a,[c_lines{1,1,r}, c_lines{3,1,r}],'rows'),1)
            continue;
        end
        dist1 = norm(c_lines{1,1,r}-point);
        dist2 = norm(c_lines{2,1,r}-point);
        if ((dist1 < maxDistance*0.8 || dist2 < maxDistance*0.8))
            c_lines{5,1,r} = 1;
            a = [a;c_lines{1,1,r}, c_lines{3,1,r}];
            [a, c_lines] = concatlines(c_lines,r,c_lines{1,1,r},a,maxDistance);
            a = [a;c_lines{2,1,r}, c_lines{3,1,r}];
            [a, c_lines] = concatlines(c_lines,r,c_lines{2,1,r},a,maxDistance);
            break;
        end
        
    end    
end