function [juryRegions,juryDiam,torso,sym]=computeRegion(V,F,endpoint,sym,D,sdf)
% Copyright (c) 2014 Shuhua Li
%D was normalized.
% 计算搜索区域
%% 首先，确定肢端范围，计算评委区域
  [idx,c]=kmeans(sdf,4);[~,locs]=max(c);t_sdf=min(sdf(idx==locs));
   empty_num=[]; 
juryRegions=cell(0,2);juryDiam=zeros(0,1);temp=zeros(size(V,1),1);k=1;
for i=1:size(sym,1) 
    for j=1:10
        tmpdiam=0.04*j;
        [~,patchIdx]=patchIndicatorFunction_landmark(sym(i,1),D,1,tmpdiam);
        tmpIdx=patchIdx~=0;
        fea=max(sdf(tmpIdx));
        if fea>t_sdf || j==10
            juryDiam(end+1)=tmpdiam-0.04;
            [~,patchIdx1]=patchIndicatorFunction_landmark(sym(i,1),D,1,juryDiam(end));
            tmpIdx1=find(patchIdx1~=0);
            juryRegions(end+1,1)={tmpIdx1};
            temp=temp+k*patchIdx1;
            [~,patchIdx2]=patchIndicatorFunction_landmark(sym(i,2),D,1,juryDiam(end));
            tmpIdx2=find(patchIdx2~=0);
            juryRegions(end,2)={tmpIdx2};
            temp=temp+k*patchIdx2;k=k+1;
            if isempty(juryRegions{end,1}) || isempty(juryRegions{end,2})
                juryRegions(end,:)=[];
                empty_num(end+1)=i;
            end
            break;
        end
    end
end

torso=find(temp==0);
sym(empty_num,:)=[];
juryDiam(empty_num)=[];
%%
% color1=[255/255,246/255,143/255];color2=[0,191/255,0];index1=find(~temp);index2=find(temp);
% f=zeros(length(temp),3);
%     f(index1,:)=repmat(color1,length(index1),1);
%     f(index2,:)=repmat(color2,length(index2),1);
% RR_plot_sym_corr(V,F,sym(:,1),sym(:,2),f,endpoint,'');
