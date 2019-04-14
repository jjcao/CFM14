function Ring = compute_vertex_krings(V,F,K)
%==========================================================================
% Compute each vertex's K-ring vertex
% Input:  V,F, K is the rings we want to compute
% Output: Ring is a cell, Ring = Ring(nov,K)
%         the ring of one vertice did not include itself
% Created at 2011-5-8 19:48:38 wangxiaochao
%==========================================================================
%%
nov = size(V,1);
% Construct connect matrix
W = triangulation2adjacency(F);
Ring = cell(nov,K);
for i = 1:K
    for j = 1:nov
        Ring{j,i} = find(W(j,:));
    end
    W = W*W;
    W = spones(W);
end
