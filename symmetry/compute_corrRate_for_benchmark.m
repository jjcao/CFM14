function [corrRate,geodesicError,tau,sample_d]=...
    compute_corrRate_for_benchmark(V,F,benchmarkSym,sampleCorr,maximal_d,sample_d)
% Copyright (c) 2014.07.05 Shuhua Li
if nargin < 5
     nverts=size(V,1);sample_d=sparse(nverts,nverts);
     A = triangulation2adjacency(F);
     ind = find(A>0);
     [I, J] = ind2sub(size(A), ind);
     dist2 = sum((V(I,:) - V(J,:)).^2, 2);
     W = sparse(I,J, sqrt(dist2) );
     start_points=unique(benchmarkSym); 
     sample_d(:,start_points) = perform_dijkstra_fast(W, start_points)';
     if max(max(sample_d(:,start_points)))==Inf
         error('the mesh has isolated point');
     end
     sample_d_ori=sample_d;
     maximal_d = max(max(sample_d(:,start_points)));
     sample_d(:,start_points)=sample_d(:,start_points)/maximal_d;
 end
 if nargin == 5
     nverts=size(V,1);sample_d=sparse(nverts,nverts);
     A = triangulation2adjacency(F);
     ind = find(A>0);
     [I, J] = ind2sub(size(A), ind);
     dist2 = sum((V(I,:) - V(J,:)).^2, 2);
     W = sparse(I,J, sqrt(dist2) );
     start_points=unique(benchmarkSym); 
     sample_d(:,start_points) = perform_dijkstra_fast(W, start_points)';
     if max(max(sample_d(:,start_points)))==Inf
         error('the mesh has isolated point');
     end
     sample_d_ori=sample_d;
     sample_d(:,start_points)=sample_d(:,start_points)/maximal_d;
 end
%%
faceArea = compute_area_faces(V,F);
area=sum(faceArea);
N=20;
tau=sqrt(area/(pi*N));

geodesicError=diag(full(sample_d(sampleCorr,benchmarkSym)));
corrRate=sum(geodesicError<tau)/length(benchmarkSym);

