function sampleCorr=compute_symmetry_for_samples(V,F,eigvector,juryC,bodyC,sample,juryRegions,torso,options,string)
% Copyright (c) 2014 Shuhua Li
% 针对较多的采样点
%%
sampleCorr=[];

tmp=ismember(sample,torso);
if sum(tmp)
   searchSpace=eigvector(torso,:);
   atria = nn_prepare(searchSpace);
   [idx, ~] = nn_search(searchSpace,atria,eigvector(sample(tmp),:)*bodyC',1);
   clear atria;
   sampleCorr=[sampleCorr;sample(tmp),torso(idx)]; 
end
%% plot
if options.symmetry_map
figure('name',string); set(gcf,'color','white');
options.alfa = 0.1;
h = plot_mesh(V, F, options); 
set(h, 'edgecolor', 'none'); set(h, 'FaceColor', 'white');set(h, 'FaceAlpha', 0.6); 
hold on;
for i=1:size(sampleCorr,1)
x = [ V(sampleCorr(i,1),1)';(V( sampleCorr(i,2),1))'];
y =  [ V(sampleCorr(i,1),2)';(V( sampleCorr(i,2),2))'];
z =  [ V( sampleCorr(i,1),3)';(V( sampleCorr(i,2),3))'];
h = line(x,y,z, 'LineWidth', 2.5,'Color',[0 0.3 1]);
hold on;
end
end
%%
for i=1:size(juryRegions,1)
    tmp1=ismember(sample,juryRegions{i,1});
    tmp2=ismember(sample,juryRegions{i,2});
    if sum(tmp1)
        searchSpace=eigvector(juryRegions{i,2},:);
        atria = nn_prepare(searchSpace);
        [idx, ~] = nn_search(searchSpace,atria,eigvector(sample(tmp1),:)*juryC',1);
        clear atria;
        corr1=[sample(tmp1),juryRegions{i,2}(idx)]; 
    else
        corr1=zeros(0,2);
    end
    if sum(tmp2)
        searchSpace=eigvector(juryRegions{i,1},:);
        atria = nn_prepare(searchSpace);
        [idx, ~] = nn_search(searchSpace,atria,eigvector(sample(tmp2),:)*juryC',1);
        clear atria;
        corr2=[sample(tmp2),juryRegions{i,1}(idx)];
    else
        corr2=zeros(0,2);
    end
    corr=[corr1;corr2];
    sampleCorr=[sampleCorr;corr];
    %% plot
if options.symmetry_map
    for i=1:size(corr,1)
    x = [ V(corr(i,1),1)';(V( corr(i,2),1))'];
    y =  [ V(corr(i,1),2)';(V( corr(i,2),2))'];
    z =  [ V( corr(i,1),3)';(V( corr(i,2),3))'];
    h = line(x,y,z, 'LineWidth', 2.5,'Color',[0 0.3 1]);
    hold on;
    end
end
end
%% plot
if options.symmetry_map
   axis off; axis equal;view3d rot;
end