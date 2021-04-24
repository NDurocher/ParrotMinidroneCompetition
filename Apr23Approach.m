clear;
clc;
close all;


pic = imread("Corner.png");
lineWidthInPixel=90;
% pic = imread("goal.jpg");
% lineWidthInPixel=110;

BW = edge(pic(:,:,1),'prewitt');
% imshow(BW)
sceleton=bwmorph(BW,'thin',Inf);
[H,theta,rho] = hough(BW);


nHoodSize = int32(size(H)/50);
nHoodSize = double(nHoodSize);
P = houghpeaks(H,50,'threshold',ceil(0.1*max(H(:))), 'NHoodSize', [1,1]);
x = theta(P(:,2));
y = rho(P(:,1));


lines = houghlines(BW,theta,rho,P,'FillGap',50,'MinLength',lineWidthInPixel);
[lines(:).visited] = deal(0);

figure
imshow(BW)
hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
impixelinfo
%% Test
uniqueTheta = unique([lines(:).theta]);
concLines = concatAllLines(lines, lineWidthInPixel);
if(size(fieldnames(concLines),1)==1)
    %looks like we only found one line, most likely because we're at the
    %starting point or infront of us is the goal, so let's remove the cross
    %section manually...
    linesWithoutOutlier= lines(not(isoutlier([lines.theta])));
    concLines = concatAllLines(linesWithoutOutlier, lineWidthInPixel);
    
end

line1=splitLineInSegments(concLines.Line1);
line2=splitLineInSegments(concLines.Line2);

%% Looks like the split up did not work properly, let's remove the shortest segment and hope for the best...
if(size(line1,1)~=size(line2,1))
    while(size(line1,1)>size(line2,1))
        [val,idx]=min(line1(:,4));
        line1(idx:idx+1,:)=[];
    end
    while(size(line2,1)>size(line1,1))
        [val,idx]=min(line2(:,4));
        line2(idx:idx+1,:)=[];
    end
end
for i=1:2:size(line1,1)
    xDiff = abs(line1(i,1)-line1(i+1,1));
    yDiff = abs(line1(i,2)-line1(i+1,2));
    if(xDiff>yDiff)
        if(line1(i,1)>line1(i+1,1))
            line1([i,i+1],:)=line1([i+1,i],:);
        end
        if(line2(i,1)>line2(i+1,1))
            line2([i,i+1],:)=line2([i+1,i],:);
        end
    else
         if(line1(i,2)>line1(i+1,2))
            line1([i,i+1],:)=line1([i+1,i],:);
        end
        if(line2(i,2)>line2(i+1,2))
            line2([i,i+1],:)=line2([i+1,i],:);
        end
    end
end
centerLine = (line1(:,1:2)+line2(:,1:2))./2;
centerLine = orderCenterline(centerLine);
hold on
plot(centerLine(:,1), centerLine(:,2),'LineWidth',2,'Color','red')

function [ordered] = orderCenterline(centerLine)
    dist = squareform(pdist(centerLine));
    dist(dist==0)=NaN;
    ignore=[];
    ordered = [];
   
    [row,column]=find(dist==min(dist));
    for i=1:size(row) 
        if(any(ignore==row(i)) || any(ignore==column(i)))
            continue
        end
        %we need to bring row and column value of i together...
        if(mod(row(i),2)==1)
            addFirst = row(i)+1;
            addSecond = row(i);
        else
            addFirst = row(i)-1;
            addSecond = row(i);
        end
         if(mod(column(i),2)==1)
            addThird = column(i);
            addForth = column(i)+1;
        else
            addThird = column(i);
            addForth = column(i)-1;
        end
        ordered=[ordered;centerLine(addFirst,:);centerLine(addSecond,:)];
        ordered=[ordered;centerLine(addThird,:);centerLine(addForth,:)];
        ignore=[ignore, addFirst, addSecond, addThird,addForth];
    end
end
function [result] = splitLineInSegments(line)
    lineTol = absTol(line(:,3),1);
    foundLine=[];
    for i=1: size(lineTol,1);
       minV = min(cell2mat(lineTol(i)));
       maxV = max(cell2mat(lineTol(i)));
       inRange = line(find(line(:,3)<=maxV&line(:,3)>=minV),:);
       inRange(:,[1,2]);
       dist = squareform(pdist(inRange(:,[1,2]))');
       maxDist = max(max(dist));
       [x,y]=find(dist==maxDist,1);
       foundLine=[foundLine;inRange(x,:),maxDist; inRange(y,:),maxDist];
    end
    result = foundLine;
end

function [result] = absTol(list, absTol)
    uniqueVal = sort(unique(list));
    result = struct([]);
    structIdx = 1;
    if(size(uniqueVal)>0)
        c=uniqueVal(1);
    end
    for i=2:size(uniqueVal)
        if(abs(uniqueVal(i)-uniqueVal(i-1))<=absTol)
            c=[c,uniqueVal(i)];
        else
            result(1).("Idx"+string(structIdx)) = [c];
            structIdx=structIdx+1;
            c=uniqueVal(i);
        end
    end
   result(1).("Idx"+string(structIdx)) = [c];
   result = struct2cell(result);
end

function [concLines]=concatAllLines(lines, lineWidthInPixel)
concLines = struct([]);
i=1;
    while(sum([lines(:).visited]==0))
        startSearchIdx = find([lines(:).visited]==0,1);
        lines(startSearchIdx).visited = 1;
        vectorSize = 0;
        a =[lines(startSearchIdx).point1, lines(startSearchIdx).theta;lines(startSearchIdx).point2, lines(startSearchIdx).theta];
        while(size(a,1)~=vectorSize)
            vectorSize = size(a,1);
            maxDistance = lineWidthInPixel*0.8;
            [a,lines] = concatlines(lines,startSearchIdx,lines(startSearchIdx).point1,a,maxDistance);
            [a,lines] = concatlines(lines,startSearchIdx,lines(startSearchIdx).point2,a,maxDistance);
        end
    %     l1=a
         concLines(1).("Line"+string(i)) = [a];
        i=i+1;
    end
    
end
function [a, lines] = concatlines(lines,lineidx,point,a,maxDistance)
%   
    for i = 1:size(lines(:),1)
        if i == lineidx
            continue;
        elseif sum(ismember(a,[lines(i).point1, lines(i).theta],'rows'))
            continue;
        end
        dist1 = norm(lines(i).point1-point);
        dist2 = norm(lines(i).point2-point);
        if ((dist1 < maxDistance*0.8 || dist2 < maxDistance*0.8))
            lines(i).visited = 1;
            a = [a;lines(i).point1, lines(i).theta];
            [a,lines] = [concatlines(lines,i,lines(i).point1,a,maxDistance)];
            a = [a;lines(i).point2, lines(i).theta];
            [a,lines] = [concatlines(lines,i,lines(i).point2,a,maxDistance)];
            break;
        end
        
    end    
end













