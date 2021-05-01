clear;
clc;
close all;


pic = imread("Capture.jpg");

BW = edge(pic(:,:,1),'prewitt');
% imshow(BW)
sceleton=bwmorph(BW,'thin',Inf);
[H,theta,rho] = hough(BW);

% figure
% imshow(imadjust(rescale(H)),[],...
%        'XData',theta,...
%        'YData',rho,...
%        'InitialMagnification','fit');
% xlabel('\theta (degrees)')
% ylabel('\rho')
% axis on
% axis normal 
% hold on
% colormap(gca,hot)

nHoodSize = int32(size(H)/50);
nHoodSize = double(nHoodSize);
P = houghpeaks(H,10,'threshold',ceil(0.1*max(H(:))), 'NHoodSize', [1,1]);
x = theta(P(:,2));
y = rho(P(:,1));
% plot(x,y,'s','color','green');
% hold off

lines = houghlines(BW,theta,rho,P,'FillGap',50,'MinLength',70);


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
%% Test
uniqueTheta = unique([lines(:).theta]);
test = zeros(2);
straightLine=[];
impixelinfo
for t=1:length(uniqueTheta)
    laneL=[];
    laneR=[];
    for k=1:length(lines)
        if(lines(k).theta==uniqueTheta(t))
            theta = lines(k).theta;
            if(isempty(laneL))
                laneL=[laneL,lines(k)];
            else
                v1 = [laneL(1).point1,0]- [laneL(1).point2,0];
                v2 = [laneL(1).point1,0]-[lines(k).point2,0];
                angle = dot(v1,v2)/(norm(v1)*norm(v2));
                if (angle >=0.999 && angle <=1.001)
                    laneL=[laneL,lines(k)];
                else
                    laneR=[laneR,lines(k)];
                end
            end
        end
    end
    x1=[];
    y1=[];
    x2=[];
    y2=[];
    for(i=1:size(laneL,2))
        x2=[x2;laneL(i).point1(1)];
        x2=[x2;laneL(i).point2(1)];
        y2=[y2;laneL(i).point1(2)];
        y2=[y2;laneL(i).point2(2)];
    end
    for(i=1:size(laneR,2))
        x1=[x1;laneR(i).point1(1)];
        x1=[x1;laneR(i).point2(1)];
        y1=[y1;laneR(i).point1(2)];
        y1=[y1;laneR(i).point2(2)];
    end
%     lanR missing
    if (~isempty(laneR))&&(~isempty(laneL))
        [x,i] = min(x1);
        y = y1(i);
        straightLine = [straightLine;x,y, uniqueTheta(t),1];
        if
        [x,i] = max(x1);
        y = y1(i);
        straightLine = [straightLine;x,y, uniqueTheta(t),1];

        [x,i] = min(x2);
        y = y2(i);
        straightLine = [straightLine;x,y, uniqueTheta(t),2];
        [x,i] = max(x2);
        y = y2(i);
        straightLine = [straightLine;x,y, uniqueTheta(t),2];
    end
end

line1 = [];
line2 = [];
for i = 1:size(straightLine,1)
    for j = 1:length(uniqueTheta)
        if straightLine(i,3) == uniqueTheta(j)
            if straightLine(i,4) == 1
                line1 = [line1;straightLine(i,1:2)];
            else
                line2 = [line2;straightLine(i,1:2)];
            end
        end
    end
end


mid1 = floor([line1(1,:)+line2(1,:);
        line1(2,:)+line2(2,:)]/2);
% mid2 = floor([line1(3,:)+line2(3,:);
%         line1(4,:)+line2(4,:)]/2);

plot(mid1(:,1),mid1(:,2),'LineWidth',2,'Color','red');
plot(mid1(1,1),mid1(1,2),'x','LineWidth',2,'Color','blue');
plot(mid1(2,1),mid1(2,2),'x','LineWidth',2,'Color','cyan');

% plot(mid2(:,1),mid2(:,2),'LineWidth',2,'Color','red');
% plot(mid2(1,1),mid2(1,2),'x','LineWidth',2,'Color','blue');
% plot(mid2(2,1),mid2(2,2),'x','LineWidth',2,'Color','cyan');
% 
% plot([mid1(1,1) mid2(1,1)], [mid1(1,2), mid2(1,2)],'LineWidth',2,'Color','red');
    
    
    
    
 