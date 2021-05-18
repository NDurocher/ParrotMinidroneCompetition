function [waypointsInfront, arr] = WaypointGenerationDebug(centerLine)
if coder.target('MATLAB')
    clear;
    clc;
    close all;
    centerLine = readmatrix('waypoints.txt');
    pic = imread('waypoints.png');
    figure('Name', 'Read path');
    imshow(pic);
    impixelinfo;
    img = uint8(zeros(size(pic,1),size(pic,2)));
    arr = uint8(zeros(size(pic,1),size(pic,2)));
else
    arr = uint8(zeros(120,160));
    waypointsInfront=[];
end

[arr, waypoints]=pointsToCenterLine(centerLine,arr);
% [~, waypoints]=pointsToCenterLine(centerLine,[]);
list= single(waypoints);

coder.varsize('sortedWaypoints')
sortedWaypoints = zeros(size(list,1),4);
for i=1:size(list,1)
    [arcos,D]=getAngleToImgCenter([list(i,1), list(i,2)]);
    sortedWaypoints(i,:) = [list(i,:),arcos,D];
end
if(size(sortedWaypoints,1)==0)
    return
end
[v,i]=min(sortedWaypoints(:,4));
% We got a list of sorted waypoints, but we don't know whats up and down...
% Straight up gives us an angle of 1, straigt down of -1, so let's go in
% this direction where we get the higher number of the next couple of
% angles
elementsUpwards=(size(sortedWaypoints,1)-i);
upwards=sum(sortedWaypoints(i:i+elementsUpwards,3))/(elementsUpwards+1);
elementsDownwards=i;
downwards=sum(sortedWaypoints(1:i,3))/elementsDownwards;
if(upwards>downwards)
    waypointsInfront = sortedWaypoints(i:size(sortedWaypoints,1),:);
else
    waypointsInfront = sortedWaypoints(i:-1:1,:);
end
l = size(waypointsInfront,1);
guidanceWaypoints =[waypointsInfront(l-20,1:2);waypointsInfront(l,1:2)]
if coder.target('MATLAB')
    idx=sub2ind(size(img),waypointsInfront(:,1), waypointsInfront(:,2));
    img(idx)=255;
    
    figure('Name','Path to follow');
    imshow(img);
    impixelinfo;
end



