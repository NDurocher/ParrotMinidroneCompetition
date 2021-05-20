function [centerLine,arr] = fcn(Redim)
if coder.target('MATLAB')
    clear;
    clc;
    close all;
    pic = imread("TestImages/FailCorner11.png");
    imshow(pic);
else
    pic=Redim;
end
arr = uint8(zeros(size(pic,1),size(pic,2)));
% coder.varsize('centerLine',[4,2], [4,2]);
centerLine = double([4,2]);
lineWidthInPixel=25;
% pic = imread("goal.jpg");
% lineWidthInPixel=110;

BW = edge(pic(:,:,1),'prewitt');
[H,theta,rho] = hough(BW);


nHoodSize = int32(size(H)/50);
nHoodSize = double(nHoodSize);
P = houghpeaks(H,50,'threshold',ceil(0.1*max(H(:))), 'NHoodSize', [1,1]);
x = theta(P(:,2));
y = rho(P(:,1));


lines = houghlines(BW,theta,rho,P,'FillGap',lineWidthInPixel*2/3,'MinLength',lineWidthInPixel);
if isempty(lines)
    return
end
coder.varsize('c_lines');

c_linesTemp = struct2cell(lines);
cLinesSize = size(c_linesTemp,3);
c_lines = cell(5,1,cLinesSize);
for idx = 1:cLinesSize
    c_lines{1,1,idx} = c_linesTemp{1,idx};
    c_lines{2,1,idx} = c_linesTemp{2,idx};
    c_lines{3,1,idx} = c_linesTemp{3,idx};
    c_lines{4,1,idx} = c_linesTemp{4,idx};
    c_lines{5,1,idx} = 0;
end
if coder.target('MATLAB')
    figure
    imshow(BW)
    hold on
end
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   if coder.target('MATLAB')
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
       impixelinfo
   end

   % Determine the endpoints of the longest line segment
   len = norm(c_lines{1,1,k} - c_lines{2,1,k});
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

%% Test
uniqueTheta = unique([c_lines{3,:,:}]','rows');
concLines = concatAllLines(c_lines, lineWidthInPixel);
if(size(concLines,2)==1)
    %looks like we only found one line, most likely because we're at the
    %starting point or infront of us is the goal, so let's remove the cross
    %section manually...
    s = size(c_lines,3);
%     coder.varsize('linesWithoutOutlier')
    coder.varsize('isNoOutlier')
    coder.varsize('temp')
    isNoOutlier = not(isoutlier([c_lines{3,1,1:s}]));
    cellSize_ = sum(isNoOutlier==1,2);
    cellSize = cellSize_(1);
    linesWithoutOutlier=cell(5,1,cellSize);
    outlierIdx = 1;
    for idx=1:cellSize
            while(isNoOutlier(outlierIdx)==0)
                outlierIdx = outlierIdx + 1;
            end       
            linesWithoutOutlier{1,1,idx} = c_lines{1,outlierIdx};
            linesWithoutOutlier{2,1,idx} = c_lines{2,outlierIdx};
            linesWithoutOutlier{3,1,idx} = c_lines{3,outlierIdx};
            linesWithoutOutlier{4,1,idx} = c_lines{4,outlierIdx};
            linesWithoutOutlier{5,1,idx} = c_lines{5,outlierIdx};
            outlierIdx = outlierIdx + 1;
        
    end
    concLines = concatAllLines(linesWithoutOutlier, lineWidthInPixel);
end


line1 = zeros([2,4]);
line2 = zeros([2,4]);
if size(concLines,2)==2
    line1=splitLineInSegments(concLines{1});
    line2=splitLineInSegments(concLines{2});
elseif(size(concLines,2)==3)
        lineS1 = splitLineInSegments(concLines{1});
        lineS2 = splitLineInSegments(concLines{2});
        lineS3 = splitLineInSegments(concLines{3});
        if(size(lineS1,1)==4)
            line1=lineS1;
            if((lineS1(1,3)^2-lineS2(1,3)^2)<(lineS1(1,3)^2-lineS3(1,3)^2))
                line2 = [lineS2;lineS3];
            else
                line2 = [lineS3;lineS2];
            end
        elseif(size(lineS2,1)==4)
            line1 = lineS2;
            if((lineS2(1,3)^2-lineS1(1,3)^2)<(lineS2(1,3)^2-lineS3(1,3)^2))
                line2 = [lineS1;lineS3];
            else
                line2 = [lineS3;lineS1];
            end
        elseif(size(lineS3,1)==4)
            line1 = lineS3;
            if((lineS3(1,3)^2-lineS1(1,3)^2)<(lineS3(1,3)^2-lineS2(1,3)^2))
                line2 = [lineS1;lineS2];
            else
                line2 = [lineS2;lineS1];
            end
        else
            %just take the two longest segments and hope for the best...
            [v,i]=min([pdist(lineS1(:,1:2)), pdist(lineS2(:,1:2)), pdist(lineS3(:,1:2))]);
            switch(i)
                case 1 
                    line1= lineS2;
                    line2= lineS3;
                case 2
                    line1 = lineS1;
                    line2 = lineS3;
                case 3
                    line1 = lineS1;
                    line2 = lineS2;
            end
        end
else
    fprintf("Could not detect the centerLine")
    return
end

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
centerLine = floor((line1(:,1:2)+line2(:,1:2))./2);
centerLine = orderCenterline(centerLine);
[arr, waypoints] = pointsToCenterLine(centerLine, arr);

if coder.target('MATLAB')
    figure;
    imshow(arr);
    imwrite(arr, 'waypoints.png');
    writematrix(centerLine, 'waypoints.txt')
%     waypointFile = fopen('waypoints.pmc', 'w')
%     fprintf(waypointFile,centerLine);
%     WaypointGenerationDebug(centerLine);
end