function [arr, waypoints] = pointsToCenterLine(centerLine, arr)
waypoints = uint32([]);
if(size(centerLine,1)==2)
    coder.varsize('p1', [1,2]);
    coder.varsize('p2', [1,2]);
    p1 = centerLine(1,:);
    p2 = centerLine(2,:);
    [arr, waypoints] = pointsToLine(p1,p2,arr);
end
if(size(centerLine,1)==3)
    coder.varsize('p1', [1,2]);
    coder.varsize('p2', [1,2]);
    coder.varsize('p3', [1,2]);
    p1 = centerLine(1,:);
    p2 = centerLine(2,:);
    p3 = centerLine(3,:);
    [arr1, waypoints] = pointsToLine(p1,p2,arr);
    [arr2, waypoints1] = pointsToLine(p2,p3,arr);
    waypoints=[waypoints;waypoints1];
    arr = arr1 + arr2;
end
if(size(centerLine,1)>=4)
    coder.varsize('p3', [1,2]);
    coder.varsize('p4', [1,2]);
    p3=centerLine(3,:);
    p4=centerLine(4,:);
    [arr, waypointsNew] = pointsToLine(p3,p4, arr);
    waypoints=[waypoints;waypointsNew];
end