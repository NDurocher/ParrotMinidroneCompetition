img = imread("Capture.JPG")
velocity = [1 0]
% split image in half


[r, g, b] = imsplit(img);
[x y] = size(r)
binary = r>200
labelImage = bwlabel(binary);
props = regionprops(labelImage, 'Centroid', 'Orientation')
% props = regionprops(bw, 'Centroid', 'WeightedCentroid');
imshow(binary)
% stats.Centroid
hold on
plot(props.Centroid(1), props.Centroid(2),'bx', 'LineWidth',1);
hold off
xDir =  (x/2-props.Centroid(1))/x
yDir = (y/2-props.Centroid(2))/y
