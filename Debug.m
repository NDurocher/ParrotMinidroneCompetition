close all;
clear all;
img = imread("TestImages/Test17.PNG");
image(img);
title("Image")
% split image in half
[r, g, b] = imsplit(img);
[yS, xS] = size(r);
binary = r>200;
sceleton=bwmorph(binary,'thin',Inf);
%To get an array instead of matrix, we use the bwtraceboundary
%function, which will return an array around our skeleton. If we use half
%of it, we should end up closed enought to our skeleton...


%Find starting point for boundary, this will only work if we have one
%continuous line
% [xM,yM]=find(sceleton,1,'first');
% fprintf("X: %d   Y: %d",sX,sY);
r=regionprops(sceleton,'PixelList');

[B,L] = bwboundaries(binary,'noholes');
circleProps = regionprops(binary, 'Area','Centroid');
for k=1:length(circleProps)
    boundary = B{k};
    % compute a simple estimate of the object's perimeter
    delta_sq = diff(boundary).^2;    
    perimeter = sum(sqrt(sum(delta_sq,2)));   
    % obtain the area calculation corresponding to label 'k'
    area = circleProps(k).Area;
    % compute the roundness metric
    metric = 4*pi*area/perimeter^2;
    if(metric>0.85)
        centroid = stats(k).Centroid;
    end
end
xy=single([]);
list = single([]);
out = [];
for (i=1:size(r))
    xM=r(i).PixelList(1,2);
    yM=r(i).PixelList(1,1);
    boundary = bwtraceboundary(sceleton,[xM,yM],'S');
    %we're going one time around our line, so we will have each value
    %twice, so let's remove the duplicates
    boundary = unique(boundary, 'rows');
    
    [C,Ia, Ic]=unique(boundary(:,2));
    if(size(Ic,1)>size(Ia,1)*5)
        list = [list;boundary(1,:);boundary(size(boundary,1),:)-1];
    else
        list = [list;boundary];
    end
% 
%     xy = [xy;uniq]
%     out = [out;sub2ind([xS, yS], uniq(:,1), uniq(:,2))];
%     xy=uint8(uniq);
end
%Reorder list... nobody knows why but looks better ;-)
listRearanged = list;%[list(:,2), yS-list(:,1)];
hold on;
[C,Ia, Ic]=unique(listRearanged(:,2),'last');
uniq = (listRearanged(Ia,:));
if(size(uniq)>1)
    mi = double(min(uniq(:,2)));
    ma = double(max(uniq(:,2)));
    sWidth = (ma-mi)/20;
    X = zeros(1,20);
    for i = 1:size(X,2)
        X(1,i) = mi+sWidth*(i-1);
    end
    pc = pchip(double(uniq(:,2)), double(uniq(:,1)),X);
    xy = single([X;pc])';
    plot(xy(:,1), xy(:,2),'color','black','linewidth',5)

    %Well done, but for debug purpose we will undo everything, so let's create
    %an matrix from our array
end
% [C,Ia, Ic]=unique(list(:,1));
% uniq = (list(Ia,:));
% uniq = [uniq(:,1), uniq(:,2)];
% title("Unique");
% xlim([0, xS]);
% ylim([0,yS]);
% 
% X = [1:xS/20:xS];
% pc = pchip(uniq(:,1), uniq(:,2),X);
% sp = spline(uniq(:,1), uniq(:,2),X);
% mk = makima(uniq(:,1), uniq(:,2),X);
% 
% 
% figure;
% hold on;
% plot(X, pc);
% plot(X, sp);
% plot(X, mk);
% title("Fitting...");
% legend({"pchip", "spline", "makima"});
% xlim([0, xS]);
% ylim([0,yS]);
% 533   222

% out = sub2ind([xS, yS], X,sp);
% xSpeed=1;
% ySpeed=0;
% 
% %Well done, but for debug purpose we will undo everything, so let's create
% %an matrix from our array 

