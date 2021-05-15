function [arr, waypoints] = pointsToCenterLine(centerLine, arr)
waypoints = uint32([]);
if(size(centerLine,1)>=2)
    coder.varsize('p1', [1,2]);
    coder.varsize('p2', [1,2]);
    p1 = centerLine(1,:);
    p2 = centerLine(2,:);
    [arr, waypoints] = pointsToLine(p1,p2,arr);
end
if(size(centerLine,1)>=4)
    coder.varsize('p3', [1,2]);
    coder.varsize('p4', [1,2]);
    p3=centerLine(3,:);
    p4=centerLine(4,:);
    [arr, waypointsNew] = pointsToLine(p3,p4, arr);
    waypoints=[waypoints;waypointsNew];
end