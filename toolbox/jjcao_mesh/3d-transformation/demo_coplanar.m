% demo_coplanar
%  
%
% Copyright (c) 2013 Junjie Cao
clc;clear all;close all;
addpath(genpath('../../'));
DEBUG = 1;

%% input
[parts, vertices]= read_parts_obj('cr1b.obj');
if DEBUG
    figure('Name','input'); set(gcf,'color','white');hold on;
    for i=1:length(parts)
        h=trisurf(parts(i).faces,vertices(:,1),vertices(:,2),vertices(:,3), 'FaceVertexCData', vertices(:,3));     
    end
    set(h, 'edgecolor', 'none');colormap jet(256); axis off; axis equal; mouse3d;
end

%% display pair
pair = [4, 5];
[parts( pair(1)).name, '-', parts( pair(2)).name]

faces1 = parts(pair(1)).faces;
faces2 = parts(pair(2)).faces;
verts1 = vertices(min(faces1):max(faces1),:);
verts2 = vertices(min(faces2):max(faces2),:);
figure('Name','parts'); set(gcf,'color','white');hold on;axis off; axis equal; mouse3d;
h=trisurf(parts(pair(1)).faces,vertices(:,1),vertices(:,2),vertices(:,3),'faceAlpha', 0.5);
set(h, 'FaceColor', 'g');
h=trisurf(parts(pair(2)).faces,vertices(:,1),vertices(:,2),vertices(:,3),'faceAlpha', 0.5);
set(h, 'FaceColor', 'b');
scatter3(verts1(:,1),verts1(:,2), verts1(:,3),50,'g','filled');
scatter3(verts2(:,1),verts2(:,2), verts2(:,3),50,'b','filled');

%%
n1 = [-0.99981954406388474,0.017650688767871195,0.0070237094120879405];
n2 = [0.99993241315071746,-0.011234751443883625,-0.0029915699184806369];
p1 = [0.0034921637871319845,0.00000000000000000,0.00000000000000000];
plane0 = createPlane(p1, n1);
drawPlane3d(plane0, 'g');
scatter3(p1(:,1),p1(:,2),p1(:,3),100,'r','filled');
%%
p1=[-0.18528800000000001, 0.24143600000000001,0.57294599999999996];
p2=[0.20901700000000001, 0.24143600000000001,0.57177800000000001];
line0 = createLine3d(p1, p2);
drawLine3d(line0, 'b');

pos = [0.011079526250000001, -0.077051518750000006, 0.51771562500000001];
normal = [-0.0043329026204465800, -0.0068514184993272468, -0.99996714146987298];
plane0 = createPlane(pos, normal);
drawPlane3d(plane0, 'g');

p11= projPointOnPlane(p1, plane0);
p22= projPointOnPlane(p2, plane0);
scatter3(p11(:,1),p11(:,2),p11(:,3),100,'r','filled');
scatter3(p22(:,1),p22(:,2), p22(:,3),100,'r','filled');

sqrt(sum( (p1-p11).^2 )) + sqrt(sum( (p2-p22).^2 ))