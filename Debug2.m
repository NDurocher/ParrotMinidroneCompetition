% close all;
clear all;
img = imread("TestImages/Test1.PNG");
[redImage, g, b] = imsplit(img);
[yS,xS]=size(redImage);
binary = redImage>200;

mask = single(zeros(120,120));
out = 25;
in = 10;
cone_angle = 15;
for i = -90:90
outter = int8(out*[cosd(i), sind(i)]);
inner = int8(in*[cosd(i), sind(i)]);
mask(60-outter(2),60+outter(1)) = outter(2)+out*cosd(cone_angle);
mask(60-inner(2),60+inner(1)) = 1.4*outter(2)+in*cosd(cone_angle);
end
mask = mask + fliplr(mask);
imshow(mask);

%% Let's rotate it dependent on the yaw angle (good luck with it...)
yaw=189
mask1 = imrotate(mask,yaw);
origSize = size(mask);
rotateSize= size(mask1);
diffSize = abs(rotateSize-origSize)
xSize = floor(diffSize(1)/2+1:origSize(1)+diffSize(1)/2);
ySize = floor(diffSize(2)/2+1:origSize(2)+diffSize(2)/2);
if(min(xSize)<0)
    xSize = xSize+min(xSize);
end
if(min(ySize)<0)
    ySize = ySize+min(ySize);
end
mask1 = mask1(xSize,ySize);
mask1 = [zeros(120,20),mask1,zeros(120,20)];
imshow(mask1)

% img = imread("TestImages/Test17.PNG");
% image(img);
% title("Image")
% % split image in half
% [r, g, b] = imsplit(img);
% [yS, xS] = size(r);
% binary = r>200;
% imshow(binary);
% newIMg = imrotate(binary,=-10);
% imshow(newIMg)