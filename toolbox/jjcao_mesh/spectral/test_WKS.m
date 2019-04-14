%test_WKS
%
%
% Copyright (c) 2013 Junjie Cao

clc;clear all;close all;
addpath(genpath('../../'));
%% Load mesh
M.filename = 'wolf0.off';
[M.verts,M.faces] = read_mesh(M.filename);
M.nverts = size(M.verts,1);

%% Laplacian eigen
nbasis = 100;
withAreaNormalization = true;
adjustL = false;
[M.eigvector,M.eigvalue, A]=compute_Laplace_eigen(M.verts,M.faces,nbasis, withAreaNormalization, adjustL);

%% WKS
tic
M.wks = WKS(M.eigvector, M.eigvalue);
toc

%% display WKS of some vertices
shading_type = 'interp';
for i = 1:ceil(size(M.wks,2)/6):size(M.wks,2)
% for i = 1:5
    figure('Name', sprintf('eigen function: %d', i));
    h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
        'FaceVertexCData', M.wks(:,i), 'FaceColor',shading_type); 
    axis off; axis equal; set(h, 'edgecolor', 'none'); mouse3d;
end