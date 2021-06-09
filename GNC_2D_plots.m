clc
close all;

x = Out_Pos.signals.values(:,1);
y = Out_Pos.signals.values(:,2);
z = -Out_Pos.signals.values(:,3);


hold on
plot3(y,x,z,'LineWidth',2.5)
plot3(linspace(0,2.40,100),2.3 + zeros(1,100),ones(1,100), 'LineWidth',2.5, ...
    'color','r')
plot3(zeros(1,100),linspace(0,2.30,100),ones(1,100), 'LineWidth',3, ...
    'color','r')
