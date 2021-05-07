function [arr ] =pointsToLine (point1, point2, arr)
if(sum(point1==point2)==2)
    return
end
m = (point2(2)-point1(2))/(point2(1)-point1(1));
b=point1(2) - m*point1(1);

if(abs(m)<=1)
    for i = point1(1):point2(1)
        y1 = uint32(m*i+b);
        arr(y1,i) = 255;
    end
else
    m = (point2(1)-point1(1))/(point2(2)-point1(2));
    b = point1(1) - m*point1(2);
    for i = point1(2):point2(2)
        y1 = uint32(m*i+b);
        arr(i,y1) = 255;
    end
end
