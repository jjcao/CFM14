function [L,sample_d_ori,sample_d]=vote_by_juryCorr(V,F,wks,torso,...
    sym,D,juryCorr,maximal_d,opts)
% Copyright (c) 2014.07.02 Shuhua Li  
%D was normalized.
% 计算测地距离用到perform_dijkstra_fast;


%% 将多个尺度的wks极大值点取出放在wksExtrema
L=[];wksDiff=[];wksExtrema=[];
for w=size(wks,2):-5:1  %%对第i个尺度的wks的循环
    if size(L,1)>1000
        break;
    end
  [maxIdx, ~] = extrema(F,wks(:,w), 1, 1.0); 
  I=ismember(maxIdx,torso);
  maxIdx(~I)=[];
  %% 建立L0
  descriptor=wks(maxIdx,:);
  descriptor = descriptor./repmat(sqrt(sum(descriptor.^2,2)),1,size(descriptor,2));
  [tmpL,tmpL0,wksdiff] = constructL(maxIdx,descriptor);%L contain index of vertex in mesh,L0 contain index of vertex in maximaIndex
  L=[L;tmpL];wksDiff=[wksDiff;wksdiff];
end
%% 去掉重复的点对
I=L(:,1)>L(:,2);
tempI=L(I,1);
L(I,1)=L(I,2);
L(I,2)=tempI;
[L,I,J]=unique(L,'rows');
wksDiff=wksDiff(I);
%%
nverts=size(V,1);sample_d=sparse(nverts,nverts);

A = triangulation2adjacency(F);
ind = find(A>0);
[I, J] = ind2sub(size(A), ind);
dist2 = sum((V(I,:) - V(J,:)).^2, 2);
W = sparse(I,J, sqrt(dist2) );

L_sample=[L(:,1)',L(:,2)'];L_sample=unique(L_sample); 
sample_d(:,L_sample) = perform_dijkstra_fast(W, L_sample)';
if max(max(sample_d(:,L_sample)))==Inf
   error('the mesh has isolated point');
end
sample_d_ori=sample_d;
sample_d(:,L_sample)=sample_d(:,L_sample)/maximal_d;
%% voting
% 6. 代码细节： 选用哪组评委对称点对进行投票
votenum=zeros(size(L,1),1);jurynum=zeros(size(L,1),1);
for i=1:size(L,1)
    dl=zeros(size(sym,1),2);dr=zeros(size(sym,1),2);
    for j=1:size(sym,1)
        dl(j,1)=D(L(i,1),sym(j,1));dl(j,2)=D(L(i,2),sym(j,2));
        dr(j,1)=D(L(i,1),sym(j,2));dr(j,2)=D(L(i,2),sym(j,1));
    end
    dl_diff=abs(dl(:,1)-dl(:,2));
    dr_diff=abs(dr(:,1)-dr(:,2));
    d_mean=(dl(:,1)+dl(:,2)+dr(:,1)+dr(:,2))/4;
    logic=sum(dl_diff>opts.d_diff)+sum(dr_diff>opts.d_diff);
    if ~logic
        [~,k]=min(d_mean);
        jurynum(i)=size(juryCorr{k},1);
        for j=1:size(juryCorr{k},1)
            d1=sample_d(juryCorr{k}(j,1),L(i,1));
            d2=sample_d(juryCorr{k}(j,2),L(i,2));
            d3=sample_d(juryCorr{k}(j,1),L(i,2));
            d4=sample_d(juryCorr{k}(j,2),L(i,1));
            Distdiff=max(abs(d1-d2),abs(d3-d4));
            if Distdiff<opts.Distdiff
                votenum(i)=votenum(i)+1;
            end
        end
    end
end
clear dl dr d_diff d_mean logic d1 d2 d3 d4 Distdiff i j k;
%% 去掉票数少的对称点对
I=votenum>(opts.vote*jurynum);
L(~I,:)=[];votenum(~I)=[]; wksDiff(~I)=[];
%% 去掉重复的对称点对
for i=1:size(L,1)
    for j=(i+1):size(L,1)
        if L(i,1)==L(j,1) || L(i,2)==L(j,2) || L(i,1)==L(j,2) || L(i,2)==L(j,1)
            if votenum(i)>votenum(j)
                L(j,:)=[0 0]; 
            else
                L(i,:)=[0 0];
            end
        end
    end
end
I=L(:,1)==0;L(I,:)=[];votenum(I)=[];wksDiff(I)=[];
I=L(:,2)==0;L(I,:)=[];votenum(I)=[]; wksDiff(I)=[];
%% 删除测地距离小的点对
d=full(sample_d(L(:,1),L(:,2)));
dist=diag(d);
I=dist<0.05; 
L(I,:)=[];

%% 根据特征差异大的点对
[L,~]=delete_by_feature(L,wks,opts);