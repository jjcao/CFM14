%Compute the first k small eigenvalues and the coorresponding eigenvectors
%of the triangular mesh


%Hui Wang, Dec. 12, 2011, wanghui19841109@gmail.com

function [eigvector,eigvalue, mixArea] = eigenDecoLaplacian(V, F, k)

W = cotangentLaplacian_noNormalize(V, F);
mixArea = VertexCellArea(V, F);
% mixArea = mixArea / sum(mixArea);
A = sparse(1:length(mixArea), 1:length(mixArea), mixArea');
 
[eigvector, eigvalue] = eigs(W, A, k, 'sm');
% [eigvector, eigvalue] = eigs(W, k, 'sm');
eigvalue = diag(eigvalue);

%The increasing order
[eigvalue, index] = sort(eigvalue);
eigvector = eigvector(:, index);