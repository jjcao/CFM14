function [L,sample,sample_d_ori,maximal_d]=delete_by_geodesicDist(V,F,L,sample,sample_d)
% Copyright (c) 2013 Shuhua Li
% input :sample_d was not normalized.
% output :sample_d_ori was not normalized.
%%
s=[L(:,1);L(:,2)];
tempIdx=ismember(s,sample);
more_sample=s(~tempIdx);
sample=[sample;more_sample];
 options.nb_iter_max = Inf;
 for j=1:length(more_sample)
    [sample_d(:,more_sample(j)),~,~]= perform_fast_marching_mesh(V,F,more_sample(j), options);
 end
 maximal_d=max(max(sample_d(:,sample)));sample_d_ori=sample_d;
 sample_d(:,sample)=sample_d(:,sample)/maximal_d;
% D=sample_geodesic(V,F,L(:,2));
% D(:,L(:,2))=D(:,L(:,2))/maximal_d;
d=full(sample_d(L(:,1),L(:,2)));
dist=diag(d);
I=dist<0.05; 
L(I,:)=[];