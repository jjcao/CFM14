function juryCorr=compute_juryCorr(eigvector,juryRegions,C1,sample)
% Copyright (c) 2013 Shuhua Li

%% jurySamples
jurySamples=cell(0,2);%refineSamples=[];
for i=1:size(juryRegions,1)
    tmpIdx1=ismember(juryRegions{i,1},sample);tmpIdx2=ismember(juryRegions{i,2},sample);
    jurySamples(i,1)={juryRegions{i,1}(tmpIdx1)}; jurySamples(i,2)={juryRegions{i,2}(tmpIdx2)};
%     refineSamples=[refineSamples;jurySamples{i,1};jurySamples{i,2}];
end
% %% 3. 代码细节：refine C1得到C2
% C2 = refine_C(C1,eigvector, eigvector,nbr_iter,refineSamples); 
%% compute jury corr
juryCorr=cell(0,1);
for i=1:size(juryRegions,1)
    if ~isempty(jurySamples{i,1})
%     searchSpace=eigvector(juryRegions{i,2},:);
    searchSpace=eigvector(jurySamples{i,2},:);
    atria = nn_prepare(searchSpace);
%     [tmpIdx, ~] = nn_search(searchSpace,atria,eigvector(juryRegions{i,1},:)*C1',1);
    [tmpIdx, ~] = nn_search(searchSpace,atria,eigvector(jurySamples{i,1},:)*C1',1);
    clear atria;
%      corr1=[jurySamples{i,1},juryRegions{i,2}(tmpIdx)];
    corr1=[jurySamples{i,1},jurySamples{i,2}(tmpIdx)];

%     searchSpace=eigvector(juryRegions{i,1},:);
    searchSpace=eigvector(jurySamples{i,1},:);
    atria = nn_prepare(searchSpace);
%     [tmpIdx, ~] = nn_search(searchSpace,atria,eigvector(juryRegions{i,2},:)*C1',1);
    [tmpIdx, ~] = nn_search(searchSpace,atria,eigvector(jurySamples{i,2},:)*C1',1);
    clear atria;
%     corr2=[jurySamples{i,2},juryRegions{i,1}(tmpIdx)];
     corr2=[jurySamples{i,2},jurySamples{i,1}(tmpIdx)];
    corr=[corr1;corr2];
   %% 去掉重复的点对
   I=corr(:,1)>corr(:,2);
   tempI=corr(I,1);
   corr(I,1)=corr(I,2);
   corr(I,2)=tempI;
   [corr,~,~]=unique(corr,'rows');
   juryCorr(end+1)={corr};
    end
end