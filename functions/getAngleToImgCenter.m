%Point has to be in format; y,x
function [angle, distance] = getAngleToImgCenter(point)
straight = [1,0];
refV = single([60-point(1), point(2)-80]);
distance = sum(refV*refV',2);
ang= dot(straight,refV)/(norm(refV));
cs = cos(ang);
sn = sin(ang);
angle = atan2(sn,cs);
if(isnan(angle))
    angle=single(0);
end