clear;
clc;
close all;


pic = imread("Capture.jpg");

BW = edge(pic(:,:,1),'prewitt');
% imshow(BW)
sceleton=bwmorph(BW,'thin',Inf);
[H,theta,rho] = hough(BW);


nHoodSize = int32(size(H)/50);
nHoodSize = double(nHoodSize);
P = houghpeaks(H,10,'threshold',ceil(0.1*max(H(:))), 'NHoodSize', [1,1]);
x = theta(P(:,2));
y = rho(P(:,1));


lines = houghlines(BW,theta,rho,P,'FillGap',50,'MinLength',30);


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
a =[lines(1).point1;lines(1).point2];
a = concatlines(lines,1,lines(1).point1,a);
a = concatlines(lines,1,lines(1).point2,a);



function a = concatlines(lines,lineidx,point,a)
% 
    for i = 1:size(lines(:),1)
        if i == lineidx
            continue;
        elseif sum(ismember(a,lines(i).point1,'rows'))
            continue;
        end
        dist = norm(lines(i).point1-point);
        if dist < 20
            a = [a;lines(i).point1];
            a = [concatlines(lines,i,lines(i).point1,a)];
            break;
        end
        
    end
    for i = 1:size(lines(:),1)
        if sum(ismember(a,lines(i).point2,'rows'))
            continue;
        end
        dist = norm(lines(i).point2-point);
        if dist < 20
            a = [a;lines(i).point2];
            a = [concatlines(lines,i,lines(i).point2,a)];
            break;
        end
        
    end
    
end















