function [patchFun,patchIdx]=patchIndicatorFunction_landmark(landmark,D,npatches,stepDist)
%[patchFun,patchIdx]=patchIndicatorFunction_landmark(landmark,D,npatches,stepDist,opts)
%input: 
%       D was normalized.
%   Copyright (c) 2013 Shuhua Li
% if ~isfield(opts, 'start_radius')
    opts.start_radius =0;
% end
%%
num=length(landmark);
%% 
d=full(D(:,landmark));
%%
nverts=size(d,1);
patchFun=zeros(nverts,num*npatches);k=1;
patchIdx=zeros(nverts,num);
for i=1:num  % 对每一landmarks 循环
    radius=opts.start_radius;
    pradius=opts.start_radius;
    for j=1:npatches  
        radius=radius+stepDist;
        temp=(d(:,i)<radius) + ~(d(:,i)<pradius);
      
        tempIdx= temp==2;
        
        patchFun(tempIdx,k)=1;k=k+1;
        patchIdx(tempIdx,i)=j;
    
        pradius = radius;
    end
end
