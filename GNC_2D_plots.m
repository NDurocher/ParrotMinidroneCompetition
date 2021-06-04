clc
close all;

x = Posout.signals.values(:,1);
y = Posout.signals.values(:,2);
z = -Posout.signals.values(:,3);


hold on
plot3(y,x,z,'LineWidth',2.5, 'LineSpec','r--')
plot3(linspace(0,2.40,100),2.3 + zeros(1,100),ones(1,100), 'LineWidth',2.5, ...
    'color','b')
plot3(zeros(1,100),linspace(0,2.30,100),ones(1,100), 'LineWidth',3, ...
    'color','b')
