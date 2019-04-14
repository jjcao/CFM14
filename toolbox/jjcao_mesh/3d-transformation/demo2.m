%
%  
%
% Copyright (c) 2013 Junjie Cao
clc;clear all;close all;
addpath(genpath('../../'));
DEBUG = 1;

%% input
BarTop = [0.293195, 0.363208, 1.38009
0.273968, 0.36307, 1.37754
0.25467, 0.362952, 1.3756
0.235315, 0.362821, 1.37434
0.215936, 0.362648, 1.37355
0.196547, 0.362448, 1.37312
0.177155, 0.362206, 1.37351
0.157766, 0.36191, 1.37392
0.138373, 0.361663, 1.37414
0.118992, 0.361552, 1.37492
0.099642, 0.361646, 1.37619
0.0803398, 0.362023, 1.37806
0.0610625, 0.362541, 1.38014
0.0417726, 0.362902, 1.38208
0.0224478, 0.363303, 1.38368
0.00319045, 0.3645, 1.38566
-0.0160554, 0.365908, 1.38762
-0.0353928, 0.36636, 1.38898
-0.0547735, 0.366077, 1.38953
-0.0741538, 0.365506, 1.38949
-0.0933258, 0.364414, 1.38683
-0.112223, 0.363512, 1.38256
-0.131062, 0.36278, 1.378
-0.150256, 0.362362, 1.37529
-0.169554, 0.362024, 1.3734
-0.188916, 0.361846, 1.37226
-0.208303, 0.361927, 1.37183
-0.227696, 0.36222, 1.37201
-0.247063, 0.362274, 1.37301
-0.266401, 0.362085, 1.3745
-0.285717, 0.361856, 1.37615
-0.304993, 0.361626, 1.37831];

BarBottom = [0.293195, 0.363208, 0.776878
0.273968, 0.36307, 0.77433
0.25467, 0.362952, 0.772394
0.235315, 0.362821, 0.771136
0.215936, 0.362648, 0.770344
0.196547, 0.362448, 0.769915
0.177155, 0.362206, 0.770305
0.157766, 0.36191, 0.770707
0.138373, 0.361663, 0.770936
0.118992, 0.361552, 0.771707
0.099642, 0.361646, 0.772979
0.0803398, 0.362023, 0.774849
0.0610625, 0.362541, 0.776935
0.0417726, 0.362902, 0.778874
0.0224478, 0.363303, 0.780475
0.00319045, 0.3645, 0.782456
-0.0160554, 0.365908, 0.784411
-0.0353928, 0.36636, 0.785771
-0.0547735, 0.366077, 0.786326
-0.0741538, 0.365506, 0.786276
-0.0933258, 0.364414, 0.783623
-0.112223, 0.363512, 0.779346
-0.131062, 0.36278, 0.774789
-0.150256, 0.362362, 0.772082
-0.169554, 0.362024, 0.770191
-0.188916, 0.361846, 0.769052
-0.208303, 0.361927, 0.768622
-0.227696, 0.36222, 0.768804
-0.247063, 0.362274, 0.769805
-0.266401, 0.362085, 0.771295
-0.285717, 0.361856, 0.772943
-0.304993, 0.361626, 0.775097];
c1 = mean(BarTop);
c2 = mean(BarBottom);
c = 0.5*(c1+c2);
figure('Name','input'); set(gcf,'color','white');hold on;
scatter3(BarTop(:,1),BarTop(:,2), BarTop(:,3),50,'g','filled');
scatter3(c1(:,1),c1(:,2), c1(:,3),100,'g','filled');
scatter3(BarBottom(:,1),BarBottom(:,2), BarBottom(:,3),50,'b','filled');
scatter3(c2(:,1),c2(:,2), c2(:,3),100,'b','filled');
scatter3(c(:,1),c(:,2), c(:,3),100,'r','filled');
axis off; axis equal; mouse3d;

%% rotate verts2 around center Axis 
center = [-0.00610979, 0.362943, 1.07664];
direction =[-0.999992, -0.00264463, -0.00297619];
angle = 3.14159;

figure('Name','c++'); set(gcf,'color','white');hold on;
scatter3(BarTop(:,1),BarTop(:,2), BarTop(:,3),50,'g','filled');
scatter3(c1(:,1),c1(:,2), c1(:,3),100,'g','filled');
scatter3(BarBottom(:,1),BarBottom(:,2), BarBottom(:,3),50,'b','filled');
scatter3(c2(:,1),c2(:,2), c2(:,3),100,'b','filled');
scatter3(center(:,1),center(:,2), center(:,3),100,'r','filled');
axis off; axis equal; mouse3d;

%%
line = [center direction];
rot = createRotation3dLineAngle(line, angle);
[axisR angle2] = rotation3dAxisAndAngle(rot);
angle2

newvertices = transformPoint3d(BarBottom,rot);
sum( sqrt(sum((BarTop - newvertices).^2,2)) )/size(BarTop,1)

scatter3(newvertices(:,1),newvertices(:,2), newvertices(:,3),50,'r','filled');