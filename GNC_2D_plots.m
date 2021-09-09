clc
close all;

x = Out_Pos.signals.values(:,1);
y = Out_Pos.signals.values(:,2);
z = -Out_Pos.signals.values(:,3);


hold on
plot3(y,x,z,'LineWidth',2.5)

x0 = [0,0];
x1 = [2.3, 0];
x2 = x1+ 2.2*[cosd(-10), sind(-10)]; % -10 deg
x3 = x2- 2.3*[sin(-10), cos(-10)]; % -10 rads
x4 = x3- 2.315*[cosd(-10), sind(-10)]; % -10 deg
x5 = x4+ 2.3*[0, 1];


plot3(linspace(0,0,100),linspace(0,0,100),linspace(0,1.6,100), 'LineWidth',2.5, ...
    'color','r')
plot3(linspace(0,x1(2),100),linspace(0,x1(1),100),1.6*ones(1,100), 'LineWidth',2.5, ...
    'color','r')
plot3(linspace(x1(2),x2(2),100),linspace(x1(1),x2(1),100),1.6*ones(1,100), 'LineWidth',2.5, ...
    'color','r')
plot3(linspace(x2(2),x3(2),100),linspace(x2(1),x3(1),100),1.6*ones(1,100), 'LineWidth',2.5, ...
    'color','r')
plot3(linspace(x3(2),x4(2),100),linspace(x3(1),x4(1),100),1.6*ones(1,100), 'LineWidth',2.5, ...
    'color','r')
plot3(linspace(x4(2),x5(2),100),linspace(x4(1),x5(1),100),1.6*ones(1,100), 'LineWidth',2.5, ...
    'color','r')
plot3(linspace(x5(2),x5(2),100),linspace(x5(1),x5(1),100),linspace(1.6,0,100), 'LineWidth',2.5, ...
    'color','r')

legend('Feedforward from Image', 'Desired')
title('Simulation Evaluation')
xlabel('Global Y-Position')
ylabel('Global X-Position')




