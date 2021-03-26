img = imread("TestImages/Test21.PNG");
[redImage, g, b] = imsplit(img);
[yS, xS] = size(redImage);

yS = 120;
xS = 160;
binary = redImage>200;
xSGreyOut = 20
mask = zeros(yS,xS);
[yS,xS] = size(mask);
for y = floor(yS/2)-20:yS
    for x=floor(xS/2-xSGreyOut):floor(xS/2+xSGreyOut)
        mask(y,x) = 1;
    end
end
for k = 0:60+20
    out = k;
    for i = -97:-83
        outter = int8(out*[cosd(i), sind(i)]);
        if(60-outter(2)<=size(mask,1))
            mask(60-outter(2),80-xSGreyOut+outter(1)) = 1;
        end
    end
end
mask = mask + fliplr(mask);
mask = logical(mask);
mask = ~mask;
imshow(mask)