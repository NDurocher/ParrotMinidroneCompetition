function [ordered] = orderCenterline(centerLine)
    coder.varsize('ordered')
    coder.varsize('ignore')
    dist = squareform(pdist(centerLine));
    dist(dist==0)=NaN;
    ignore=[];
    ordered=[];
%     ignore= zeros(1,size(centerLine,2)*2);
%     ordered = zeros(size(centerLine,2)*2,2);
    if(size(centerLine,1)<4)
        ordered=centerLine;
        return;
    end
   
    row=zeros(size(dist,2),1);
    column = zeros(size(dist,2),1);
    t= zeros(size(dist,2),1);
    [row,column,t]=find(dist==min(dist),size(dist,1));
    
    for i=1:size(row,1) 
            rowI = ignore==row(i);
        colI = ignore==column(i);
        rowT = all(rowI==0);
        colT = all(colI==0);
        if(rowT==0)
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