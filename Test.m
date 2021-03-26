clear;
clc;



pic = zeros(160,120);
test = zeros(160,120);
test(:,50:70) = 1;

imshow(test);

for i = 1:360
outter = int8(20*[cosd(i), sind(i)]);
inner = int8(8*[cosd(i), sind(i)]);
pic(80+outter(1),60+outter(2)) = outter(1)+20*cosd(20);
pic(80+inner(1),60+inner(2)) = inner(1)+8*cosd(20);
end
imshow(pic)

WP = pic.*test;

imshow(WP);

rows = sum(WP,2);
cols = sum(WP,1);

[max_x,~] = max(rows); 
[max_y,~] = max(cols);

WP_Y = mean(find(cols == max_y));
WP_X = mean(find(rows == max_x));


not_test = ~test;
not_test(WP_X,WP_Y) = 1;

imshow(not_test)
%%
subplot(2,1,1)
imshow(test);
subplot(2,1,2)
[H,T,R] = hough(test,'RhoResolution',0.5,'Theta',-90:0.5:89);
imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
  title('Hough transform of test');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);

max(H);





