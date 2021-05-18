function [arr, waypoints] =pointsToLine (point1, point2, arr)
waypoints=uint32([]);
if(sum(point1==point2)==2)
    return
end
coder.varsize('point1');
coder.varsize('point2');
m = (point2(2)-point1(2))/(point2(1)-point1(1));
b=point1(2) - m*point1(1);
forLoopDist=1;
if(abs(m)<=1)
    if(point1(1)>point2(1))
        forLoopDist=-1;
    end
    for i = point1(1):forLoopDist:point2(1)
        y1 = uint32(m*i+b);
        waypoints = [waypoints;y1,i];
        if(size(arr)>0)
            arr(y1,i) = 255;
        end
    end
else
    if(point1(2)>point2(2))
        forLoopDist=-1;
    end
    m = (point2(1)-point1(1))/(point2(2)-point1(2));
    b = point1(1) - m*point1(2);
    for i = point1(2):forLoopDist:point2(2)
        y1 = uint32(m*i+b);
        waypoints = [waypoints;i,y1];
        if(size(arr)>0)
            arr(i,y1) = 255;
        end
    end
%     if(forLoopDist>0)
%        waypoints = flipud(waypoints) 
%     end
end
