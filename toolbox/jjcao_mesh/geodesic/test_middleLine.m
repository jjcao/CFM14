% test_middleLine
% from sue

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
landmarkL=[2880];
landmarkR=[2999];

% perform the front propagation, Q contains an approximate segementation
options.nb_iter_max = Inf; % trying with a varying number of iterations: 100, 1000, Inf
[DL,SL,QL] = perform_fast_marching_mesh(verts, faces, landmarkL, options);
[DR,SR,QR] = perform_fast_marching_mesh(verts, faces, landmarkR, options);
%%
landmark=find(abs(DL-DR)<0.05);
%%
% display the result using the distance function
options.start_points = landmarkL;
plot_fast_marching_mesh(verts,faces, DL, [], options);hold on;
% plot_fast_marching_mesh(verts,faces, Q, [], options);
scatter3(verts(landmark,1), verts(landmark,2),verts(landmark,3),40,'r','filled');
view3d zoom;

