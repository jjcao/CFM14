function [landmark,D_nor,maximal_d]=endpoint_sample(V,F,agd,num)
% Copyright (c) 2013 Shuhua Li

% endpoint_sample 
% Based on the paper" Multiple Shape Correspondence by Dynamic Programming Approximation"

% input: agd must have been normalized
% output: D_nor  was normalized.

patch_param=0.2; 
move_step=20;
%%
nverts=size(V,1);
[~,maxIdx] =max(agd);
options.W = ones(nverts,1); % the speed function, for now constant speed to perform uniform remeshing
landmark = perform_farthest_point_sampling_mesh(V,F,maxIdx,num-1,options);% perform the sampling of the surface
landmark=landmark';
%% 计算测地距离 perform_fast_marching_mesh
% D_nor=sparse(nverts,nverts); D_ori=sparse(nverts,nverts);
% options.nb_iter_max = Inf;
% for i=1:length(landmark)
%   [D_ori(:,landmark(i)),~,~]= perform_fast_marching_mesh(V,F, landmark(i), options);
% end
% D_nor(:,landmark)=D_ori(:,landmark)/maximal_d;
%% 计算测地距离 perform_dijkstra_fast
D_nor=sparse(nverts,nverts);D_ori=sparse(nverts,nverts);

A = triangulation2adjacency(F);
ind = find(A>0);
[I, J] = ind2sub(size(A), ind);
dist2 = sum((V(I,:) - V(J,:)).^2, 2);
W = sparse(I,J, sqrt(dist2) );
D_ori(:,landmark) = perform_dijkstra_fast(W, landmark)';

maximal_d=max(max(D_ori(:,landmark)));
if maximal_d==Inf
   error('the mesh has isolated point');
end
D_nor(:,landmark)=D_ori(:,landmark)/maximal_d;
%%
patch=cell(0,0);
for i=1:length(landmark)
    for j=1:move_step    
          patch(i)={find(D_nor(:,landmark(i))<patch_param)}; % landmark(i)所作用的范围patch
          [val,idx]=max(agd(patch{i}));
          logic1=agd(landmark(i))==val; 
          tmp=landmark;tmp(i)=0;I=ismember(tmp,patch{i}(idx));
          logic2=sum(I);
          if logic1 && ~logic2  % 若landmark(i)为所在patch的agd最大值点，且patch内不包含其他的landmark的agd一样大
              break;            % 则 landmark为肢端点，跳出move循环
          elseif logic1 && logic2  % 若landmark(i)为所在patch的agd最大值点，且patch内包含其他的landmark的agd一样大
              temp=tmp(I);
              landmark(i)=temp(1);% 则将landmark（i)移到肢端点，跳出循环
              break;
          else                      % 若landmark(i)不为所在patch的agd最大值点，则移到agd最大值点
%            [~,J]=max(agd(patch{i}));
          landmark(i)=patch{i}(idx);
          D_ori(:,landmark(i)) = perform_dijkstra_fast(W, landmark(i))';
          D_nor(:,landmark)=D_ori(:,landmark)./maximal_d;  
          end
    end
end
[landmark,~,~]=unique(landmark); 
%%
% figure('name','endpoint_sample'); set(gcf,'color','white');
% options.alfa = 0.1;
% h = plot_mesh(V, F, options); 
% set(h, 'edgecolor', 'none'); set(h, 'FaceColor', 'white');set(h, 'FaceAlpha', 0.6); 
% hold on;axis off; axis equal;
% scatter3(V(landmark,1),V(landmark,2), V(landmark,3), 200,[0,0,0],'filled');
