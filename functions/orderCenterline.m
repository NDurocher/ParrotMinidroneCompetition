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
        % we just have one line, let's check what's up and down
%         [angle1, ~]=getAngleToImgCenter(centerLine(1,2:-1:1));
%         [angle2, ~]=getAngleToImgCenter(centerLine(2,2:-1:1));
%         if(angle1<angle2)
        ordered=centerLine;
%         else
            ordered=[centerLine(2,:);centerLine(1,:)];
%         end
        return;
    end
    
    if(size(unique(centerLine,'rows'),1) == size(centerLine, 1))
        %ordering it by the smallest difference only works if there is a
        %difference, so let's go
        row=zeros(size(dist,2),1);
        column = zeros(size(dist,2),1);
        t= zeros(size(dist,2),1);
        [row,column]=find(dist==min(dist,[],'all'));
        coder.varsize('rowI');
        coder.varsize('rowT');
        for i=1:size(row,1) 
            % the next lines: if(ingore.contains(i))-> continue
            %this got a bit ugly because of the incredible matlab c coder
            continue_=0;
            for k=1:size(ignore,2)
                if(i==ignore(k))
                    continue_=1;
                end
            end
            if(continue_==1)
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
    else
        %one value is twice here, so that's where both lines align
        [u,I,J] = unique(centerLine,'rows');
        duplicateRow= setdiff(1:size(centerLine,1), I);
        duplicateValue = centerLine(duplicateRow,:);
        uniquesIdx = not(ismember(centerLine, duplicateValue,'rows'))
        uniques = centerLine(uniquesIdx,:);
        centerLine=[uniques(1,:); duplicateValue; uniques(2,:)];
    end
end