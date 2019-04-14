% eg_trisurf
%
% If texture is needed, use Gabriel Peyre's plot_mesh in toolbox_graph 
%
% Copyright (c) 2013 Junjie Cao

clear;clc;close all;
%MYTOOLBOXROOT='E:/jjcaolib/toolbox';
MYTOOLBOXROOT='../';
addpath ([MYTOOLBOXROOT 'jjcao_mesh'])
addpath ([MYTOOLBOXROOT 'jjcao_io'])
addpath ([MYTOOLBOXROOT 'jjcao_interact'])
addpath ([MYTOOLBOXROOT 'jjcao_common'])

%% load a mesh
test_file = {[MYTOOLBOXROOT '/data/fandisk.off'],[MYTOOLBOXROOT '/data/wolf0.off'],[MYTOOLBOXROOT '/data/catHead_v131.off']};
M.filename = test_file{3};
[M.verts,M.faces] = read_mesh(M.filename);
M.nverts = size(M.verts,1);
M.edges = compute_edges(M.faces); 

%% display mesh 1
figure('Name','1'); set(gcf,'color','white');hold off;
h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
    'FaceColor', 'cyan',  'edgecolor',[1,0,0], 'faceAlpha', 0.9); axis off; axis equal; mouse3d

%% display mesh 2
figure('Name','2'); set(gcf,'color','white');hold off;
shading_type = 'flat';
h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
    'FaceVertexCData', M.verts(:,1), 'FaceColor',shading_type, 'faceAlpha', 0.9); axis off; axis equal; mouse3d
% set(h, 'edgecolor', 'none'); % cancel display of edge.

%% display mesh 3
figure('Name','3'); set(gcf,'color','white');hold off;
shading_type = 'interp';
h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
    'FaceVertexCData', M.verts(:,1), 'FaceColor',shading_type, 'faceAlpha', 0.9); axis off; axis equal; mouse3d
set(h, 'edgecolor', 'none'); % cancel display of edge.

colormap jet(256);
colorbar
% colorbar('off');
