% test perform_dijkstra_path_extraction
%
%
% Copyright (c) 2012 Junjie Cao

clear;clc;close all;
%MYTOOLBOXROOT='E:/jjcaolib/toolbox';
MYTOOLBOXROOT='../..';
addpath ([MYTOOLBOXROOT '/jjcao_mesh'])
addpath ([MYTOOLBOXROOT '/jjcao_mesh/io'])
addpath ([MYTOOLBOXROOT '/jjcao_mesh/display'])
addpath ([MYTOOLBOXROOT '/jjcao_mesh/geodesic'])
addpath ([MYTOOLBOXROOT '/jjcao_interact'])
addpath ([MYTOOLBOXROOT '/jjcao_common'])

[verts,faces] = read_mesh([MYTOOLBOXROOT '/data/catHead_v131.off']);
nverts = size(verts,1);
A = triangulation2adjacency(faces,verts);

start_points = 1;
options.end_points = round(0.8 * nverts);
[D,S] = perform_dijkstra(A, start_points, options);
path = perform_dijkstra_path_extraction(A,D,options.end_points);

figure; set(gcf,'color','white');hold on;axis off; axis equal;    
h = plot_mesh(verts, faces);
scatter3(verts(path,1), verts(path,2),verts(path,3),40,'b','filled');
view3d rot;