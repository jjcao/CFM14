% entry of code for our paper 'Properly-constrained Orthonormal Functional Maps for Intrinsic Symmetries'
% Copyright (c) Shuhua Li <sue142857@gmail.com> 2014.07.05 

close all; clc; clear;
addpath(genpath('./'));
%% set default parameters
DEBUG=1;   % plot or not
METHOD='optStiefelGBB'; % optimization method options for solving CA=B CR=SC C'C=I:'least_square','linear_system','optStiefelGBB'
nbasis=100; % the number of basis functions (eigenfunctions of the Laplace-Beltrami operator).
nhks=10;   % the dimension of descriptor HKS.
nwks=100;  % the dimension of descriptor WKS.
endpoint_num=9; % the number of samples, where the symmetry-invariant point set are extracted from.

%% specify one input mesh name
name='wolf2';  
meshname=strcat(name,'.off');

%% pre-compute basis, hks, wks, sdf and sample points
disp('1. pre-compute basis, features and samples');
% basis, hks and wks
options.normalize =true; % normalize features 
M=compute_feature(meshname,nbasis,nhks,nwks,options); 

% sdf 
M.fsdf=load(sprintf('%s.sdf.txt',name));  % load sdf on facets
M.vert_sdf=convert_sdf(M.verts,M.faces,M.fsdf); % then convert sdf to vertices 
M.vert_sdf=normalization(M.vert_sdf); % normalize sdf
M=rmfield(M,'fsdf'); % remove

% load 1024 uniform sampling point indices 
load(sprintf('%s_1024.mat',name)); 
M.sample = sample; 

%%
disp('2. compute initial symmetric point pairs and region pairs');
% compute initial symmetric point pairs
opts.DEBUG =0;
[M.endpoint,sym,M.D,M.maximal_d]=...
compute_symConstrains(M.verts,M.faces,M.agd,M.hks,M.wks,endpoint_num,opts);
if DEBUG
   plot_sym_corr(M.verts,M.faces,sym(:,1),sym(:,2),'initial symmetric point pairs');
end

%% compute region pairs based on initial symmetric point pairs
[juryRegions,juryDiam,torso,sym]=computeRegion(M.verts,M.faces,M.endpoint,sym,M.D,M.vert_sdf);

%% compute inital functional matrix 
disp('3. compute inital functional matrix C1');
hksCoef1=M.eigvector'*M.hks;wksCoef1=M.eigvector'*M.wks;
A=[hksCoef1,wksCoef1];B=[hksCoef1,wksCoef1];
[AS,BS,C1,patchFun1,patchFun2]=compute_C_for_matchings(M.eigvector,...
    M.eigvalue,A,B,sym,M.D,juryDiam,METHOD);
clear hksCoef1 wksCoef1;
%% compute symmetric point pairs as symmetry electors 
disp('4. compute symmetric point pairs as symmetry electors ');
juryCorr=compute_juryCorr(M.eigvector,juryRegions,C1,M.sample);
if DEBUG
   for i=1:size(sym,1)
       plot_sym_corr(M.verts,M.faces,juryCorr{i}(:,1),juryCorr{i}(:,2),'juryCorr');
   end
end
%% vote for more symmetric point pairs 
disp('5. vote for more symmetric point pairs ');
opts.d_diff=0.15;opts.Distdiff=0.07;opts.vote=0.5;opts.fea_diff=0.15;
[L,~,sample_d]=vote_by_juryCorr(M.verts,M.faces,M.wks,torso,...
sym,M.D,juryCorr,M.maximal_d,opts);
 if DEBUG
     plot_sym_corr(M.verts,M.faces,L(:,1),L(:,2),'body pairs');
 end
%% compute final functional matrix 
disp('6. compute final functional matrix ');
stepDist=0.01;npatches=10;
[bodyPatchFun1,~]=patchIndicatorFunction_landmark(L(:,1),sample_d,...
npatches,stepDist);
[bodyPatchFun2,~]=patchIndicatorFunction_landmark(L(:,2),sample_d,...
npatches,stepDist);
bodyPatchCoef1=M.eigvector'*bodyPatchFun1;
bodyPatchCoef2=M.eigvector'*bodyPatchFun2;
ASS=[AS,bodyPatchCoef1];BSS=[BS,bodyPatchCoef2];
C2 = compute_C(ASS, BSS, M.eigvalue, M.eigvalue,METHOD);

clear temp_sample_d bodyPatchCoef1 bodyPatchCoef2 sample_d; 
%% convert to dense symmetry map
disp('7. convert to dense symmetry map');
% Note that 'all_v' can be any one set of sample point indices, which you want to find correspondences. 
all_v=(1:100:M.nverts)'; 
options.symmetry_map=1; % plot dense symmetry map or not
denseCorr_C2=compute_symmetry_for_samples(M.verts,M.faces,M.eigvector,C2,C2,all_v,juryRegions,torso,options,sprintf('%s_C2',name));   

