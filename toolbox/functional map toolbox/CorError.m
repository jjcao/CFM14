function [avg_error, sample_error] = CorError(V2, F2, f_our, f_true)
% Compute the correspondence error based on geodesic distance
%
% input:
%    M2 = <V2, F2>
%    f_our: M1 -> M2 our correspondence represented by a D x 2 matrix.
%    f_true: M1 -> M2 true correspondence represented by a N x 2 matrix.
%
% output:
%    avg_error: average correspondence error based on geodesic distance
%    sample_error: per sample correspondence error based on geodesic distance
%
% Baochang Han adapted by Shuhua Li
% hanbc@mail.dlut.edu.cn
% 2012-07-24

% Compute the sqrt of area(M2), used for normalization later.
area_M2 = sqrt(sum(FacetArea(V2, F2)));

% Compute geodesic errors for each sample.
m = size(f_our,1);
sample_error = zeros(m,1);

% [I,J,W] = adjacency_matrix(V2,F2);
% graph_distance_matrix = sparse(I,J,W);
% 
% for i = 1 : m
%     v_true = f_true(f_true(:,1) == f_our(i,1), 2);
%     temp_D = perform_dijkstra_fast(graph_distance_matrix, f_our(i,2));
%     sample_error(i) = temp_D(v_true);
% end
%%
options.nb_iter_max = Inf;
for i=1:m
    v_true = f_true(f_true(:,1) == f_our(i,1), 2);
    temp_D = perform_fast_marching_mesh(V2, F2, f_our(i,2), options);
    sample_error(i) = temp_D(v_true);
end
%%
sample_error = sample_error/area_M2;
avg_error = sum(sample_error)/m;
