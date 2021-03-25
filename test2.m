clear;
clc;


mask = single(zeros(120,160));
out = 25;
in = 6;
cone_angle = 15;
for i = 1:360
    
outter = int32(round(out*[cosd(i), sind(i)]));
inner = int32(round(in*[cosd(i), sind(i)]));
mask(60-outter(2),80+outter(1)) = outter(2);%+out*cosd(cone_angle);
mask(60-inner(2),80+inner(1)) = outter(2);%+in*cosd(cone_angle);

end

mask(40:80,60:100)