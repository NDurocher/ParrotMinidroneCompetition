clear;
clc;
close all;

pic = imread("Corner.png");

BW = edge(pic(:,:,1),'Sobel');
% BW = pic(:,:,1);
% imshow(BW)

[H,theta,rho] = hough(BW);

figure
imshow(imadjust(rescale(H)),[],...
       'XData',theta,...
       'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal 
hold on
colormap(gca,hot)

P = houghpeaks(H,20,'threshold',ceil(0.01*max(H(:))),'NHoodsize',[1 1]);
x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','green');
hold off

lines = houghlines(BW,theta,rho,P,'FillGap',50,'MinLength',20);


figure
imshow(BW)

max_len = 0;
v = [];
perp = [];
grid on
for k = 1:length(lines)
   hold on
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end
%    % Determine the endpoints of the longest line segment
%    len = norm(lines(k).point1 - lines(k).point2);
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
%    v(k,:) = [lines(k).point2-lines(k).point1, 0, lines(k).theta];

% thetas = unique(v(:,4));
% for ii = 1:length(v)-1
%     for jj = ii+1:length(v)
%         perp = [perp; dot(v(ii,1:3),v(jj,1:3))/(norm(v(ii,1:3))*norm(v(jj,1:3))) ];
%     end
% end





