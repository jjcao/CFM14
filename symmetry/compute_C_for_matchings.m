function [AS,BS,C1,fval1,patchFun1,patchFun2,patchCoef1,patchCoef2]=compute_C_for_matchings(eigvector,eigvalue,A,B,...
sym,D,juryDiam,METHOD)
% Copyright (c) 2013 Shuhua Li
%D was normalized.
%% strengthen constrains A,B
stepDist=0.01;patchFun1=[];patchFun2=[];
for i=1:size(sym,1)
    npatches=floor(juryDiam(i)/stepDist);
    options.normal=0;
    [tmpFun1,~]=patchIndicatorFunction_landmark(sym(i,:),D,npatches,stepDist);
    patchFun1=[patchFun1,tmpFun1(:,1:npatches)];
    patchFun2=[patchFun2,tmpFun1(:,npatches+1:end)];
end
   %% compute C
   patchCoef1=eigvector'*patchFun1;   patchCoef2=eigvector'*patchFun2;
   AS=[A,patchCoef1];BS=[B,patchCoef2];
   [C1,fval1] = compute_C(AS, BS, eigvalue, eigvalue,METHOD); % Optimization 
   