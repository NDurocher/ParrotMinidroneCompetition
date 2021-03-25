clear;
clc;


mask = single(zeros(120,160));
out = 25;
in = 7;
cone_angle = 15;
temp = [];
for i = 0:90
    
outter = round(out*[cosd(i), sind(i)]);
inner = round(in*[cosd(i), sind(i)]);
mask(60-outter(2),80+outter(1)) = outter(2);%+out*cosd(cone_angle);
mask(60-inner(2),80+inner(1)) = outter(2);%+in*cosd(cone_angle);
temp = [temp;inner(2)];
end
temp;
mask(40:80,60:100)
mask = mask + fliplr(mask);