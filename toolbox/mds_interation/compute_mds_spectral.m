function verts = compute_mds_spectral(M, k)
%
%
% Section 7.2.2 of Spectral Mesh Processing_cgf10
% Texture mapping using surface flattening via multidimensional scaling_tvcg02
%    
n=size(M,1);
M = M.*M;
J = eye(n) - ones(n) / n;
B = -0.5 * J * M * J;

[eigvector,eigvalue] = eigs(B,k,'LM');
eigvalue = diag(eigvalue);
[eigvalue,index] = sort(eigvalue,'descend');
eigvector = eigvector(:,index);

everts = zeros(n,k); 
for i = 1:k
%     verts(:,i) = sqrt(eigvalue(i)) * eigvector(:,i); 
     verts(:,i) = real(sqrt(eigvalue(i)) * eigvector(:,i)); 
end

