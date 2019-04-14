function sample_d=sample_geodesic(V,F,sample,options) 
% options.method:  'dijkstra' or 'marching'
% options.maximal_d
% options.normalize: 0,1
% Copyright (c) 2014.07 Shuhua Li

METHOD = getoptions(options,'method','dijkstra'); % 默认 ‘dijkstra’
NORMALIZE = getoptions(options,'normalize',0); % 默认不归一化

nverts=size(V,1);
sample_d=sparse(nverts,nverts); 

if strcmp(METHOD,'marching')
    options.nb_iter_max = Inf;
    for j=1:length(sample)
       [sample_d(:,sample(j)),~,~]= perform_fast_marching_mesh(V,F, sample(j), options);
    end
end

if strcmp(METHOD,'dijkstra')
     A = triangulation2adjacency(F);
     ind = find(A>0);
     [I, J] = ind2sub(size(A), ind);
     dist2 = sum((V(I,:) - V(J,:)).^2, 2);
     W = sparse(I,J, sqrt(dist2) ); 
     sample = unique(sample);
     sample_d(:,sample) = perform_dijkstra_fast(W, sample)';
end

if max(max(sample_d(:,sample)))==Inf
  error('the mesh has isolated point');
end
if NORMALIZE
    MAXIMAL_D = getoptions(options,'maximal_d',max(max(sample_d(:,sample))));
    sample_d(:,sample)=sample_d(:,sample)/MAXIMAL_D;
end
