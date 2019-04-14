%
% Copyright (c) 2013 Junjie Cao

clc;clear all;close all;
addpath(genpath('../../'));

%% load a mesh
test_file = {'/data/fandisk.off','/data/wolf0.off','/data/catHead_v131.off'};
M.filename = test_file{2};
[M.verts,M.faces] = read_mesh(M.filename);
M.nverts = size(M.verts,1);

tic
withAreaNormalization = 1;
adjustL = 0;
[eigvec, eigv]=compute_Laplace_eigen(M.verts,M.faces,100, withAreaNormalization, adjustL);
toc

%% display basis function
shading_type = 'interp';
% for i = 1:ceil(length(eigv)/9):length(eigv)
for i = 1:5
    figure('Name', sprintf('eigen function: %d', i));
    h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
        'FaceVertexCData', eigvec(:,i), 'FaceColor',shading_type); 
    axis off; axis equal; set(h, 'edgecolor', 'none'); mouse3d;
end



