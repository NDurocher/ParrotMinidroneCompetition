function [result] = splitLineInSegments(line)
    lineTol = absTol(line(:,3),1);
    foundLine=[];
    for i=1: size(lineTol,1)
       minV = lineTol(i,1);
       maxV = lineTol(i,2);
       inRange = line(find(line(:,3)<=maxV&line(:,3)>=minV),:);
       inRange(:,[1,2]);
       dist = squareform(pdist(inRange(:,[1,2]))');
       maxDist = max(max(dist));
       [x,y]=find(dist==maxDist,1);
       foundLine=[foundLine;inRange(x,:),maxDist; inRange(y,:),maxDist];
    end
    result = foundLine;
end