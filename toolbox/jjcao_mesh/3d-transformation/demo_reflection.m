% demo_reflection
%  
%
% Copyright (c) 2013 Junjie Cao
clc;clear all;close all;
addpath(genpath('../../'));
DEBUG = 1;
USE_PAIR = 0;

%% input
[parts, verts]= read_parts_obj('SimpleChair1.obj');
if DEBUG
    figure('Name','input'); set(gcf,'color','white');hold on;
    for i=1:length(parts)
        h=trisurf(parts(i).faces,verts(:,1),verts(:,2),verts(:,3), 'FaceVertexCData', verts(:,3));     
    end
    set(h, 'edgecolor', 'none');colormap jet(256); axis off; axis equal; mouse3d;
end
%% display pair
figure('Name','parts'); set(gcf,'color','white');hold on;axis off; axis equal; mouse3d;
if USE_PAIR
    pair = [4, 5];
    [parts( pair(1)).name, '-', parts( pair(2)).name]
    faces1 = parts(pair(1)).faces;
    faces2 = parts(pair(2)).faces;
    verts1 = verts(min(faces1):max(faces1),:);
    verts2 = verts(min(faces2):max(faces2),:);
    %    
    h=trisurf(parts(pair(1)).faces,verts(:,1),verts(:,2),verts(:,3),'faceAlpha', 0.5);
    set(h, 'FaceColor', 'g');
    h=trisurf(parts(pair(2)).faces,verts(:,1),verts(:,2),verts(:,3),'faceAlpha', 0.5);
    set(h, 'FaceColor', 'b');
    scatter3(verts1(:,1),verts1(:,2), verts1(:,3),50,'g','filled');
    scatter3(verts2(:,1),verts2(:,2), verts2(:,3),50,'b','filled');    
else
    faces1 = [];
    for i=1:length(parts)
        faces1 = [faces1; parts(i).faces];
    end
    
    faces2 = faces1;
    verts1 = verts;
    verts2 = verts;
    h=trisurf(faces1,verts(:,1),verts(:,2),verts(:,3),'faceAlpha', 0.5);
    set(h, 'FaceColor', 'b');
    scatter3(verts1(:,1),verts1(:,2), verts1(:,3),50,'b','filled');        
end

%%
if USE_PAIR
    c1 = mean(verts1);
    c2 = mean(verts2);
    center = 0.5*(c1+c2);
    line0 = createLine3d(c1, c2);    
    drawLine3d(line0, 'b');
    normal = c1-c2;
else
    center = mean(verts);
    normal = [1,0,0];
    center = [0,2.77556e-17,0.57881];
    normal = [-1,2.67949e-08,0];
    drawVector3d(center, normal, 'b');
end
scatter3(center(:,1),center(:,2), center(:,3),100,'r','filled');
normal = normal./sqrt(dot(normal,normal));
plane0 = createPlane(center, normal);
drawPlane3d(plane0, 'g');

verts2new = reflect_points(verts2, center, normal);
scatter3(verts2new(:,1),verts2new(:,2), verts2new(:,3),50,'r','filled');

%% distance 
[dist1, dist2] = dist_between_parts(verts1, verts2new);
(dist1+dist2)*0.5

% p1 = min(verts1);
% p2 = max(verts1);
% sqrt( sum( (p1-p2).^2))
% 
% p1 = min(verts2);
% p2 = max(verts2);
% sqrt( sum( (p1-p2).^2))