% test_perform_fast_marching_mesh
%
%
% Copyright (c) 2012 Junjie Cao

clear;clc;close all;
%MYTOOLBOXROOT='E:/jjcaolib/toolbox';
MYTOOLBOXROOT='../..';
addpath ([MYTOOLBOXROOT '/jjcao_mesh'])
addpath ([MYTOOLBOXROOT '/jjcao_io'])
addpath ([MYTOOLBOXROOT '/jjcao_plot'])
addpath ([MYTOOLBOXROOT '/jjcao_mesh/geodesic'])
addpath ([MYTOOLBOXROOT '/jjcao_interact'])
addpath ([MYTOOLBOXROOT '/jjcao_common'])

%%
[verts,faces] = read_mesh([MYTOOLBOXROOT '/data/wolf0.off']);
nverts = size(verts,1);
%%
%landmark = [2686,4132]+1;% start points
landmark=[2880,2999];

% perform the front propagation, Q contains an approximate segementation
options.nb_iter_max = Inf; % trying with a varying number of iterations: 100, 1000, Inf
[D,S,Q] = perform_fast_marching_mesh(verts, faces, landmark, options);

% display the result using the distance function
options.start_points = landmark;
plot_fast_marching_mesh(verts,faces, D, [], options);hold on;
% plot_fast_marching_mesh(verts,faces, Q, [], options);
scatter3(verts(landmark,1), verts(landmark,2),verts(landmark,3),40,'r','filled');
view3d zoom;

