function [result] = splitLineInSegments(line)
    tolerance = 5;
    lineTol = absTol(line(:,3),tolerance);
    foundLine=[];
    loopRange = size(lineTol,1);
    if(loopRange>2)
        loopRange=2;
    end
    for i=1: loopRange
       minV = lineTol(i,1);
       maxV = lineTol(i,2);
       inRange = line(find(line(:,3)<=maxV&line(:,3)>=minV),:);
       if(minV <tolerance-90 && max(lineTol(size(lineTol,1),:))>90-tolerance);
           minV = min(lineTol(size(lineTol,1),:));
           maxV = max(lineTol(size(lineTol,1),:));
           inRange = [inRange;line(find(line(:,3)<=maxV&line(:,3)>=minV),:)];
       end
       dist = squareform(pdist(inRange(:,[1,2]))');
       maxDist = max(max(dist));
       [x,y]=find(dist==maxDist,1);
       foundLine=[foundLine;inRange(x,:),maxDist; inRange(y,:),maxDist];
    end
    result = foundLine;
end