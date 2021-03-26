img = imread("TestImages/Test21.PNG");
[redImage, g, b] = imsplit(img);
[yS, xS] = size(redImage);
binary = redImage>200;
xSGreyOut = xS/10;
mask = ones(yS,xS);
for y = floor(yS/2)-20:yS
    for x=floor(xS/2-xSGreyOut):floor(xS/2+xSGreyOut)
        mask(y,x) = 0;
    end
end
imshow(mask)