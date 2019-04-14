function C = refine_C(C,eigvector1, eigvector2,nbr_iter,landmark)
%
% reference to 6.1 of sunjian 2009: sgp09_A Concise and Provably Informative Multi-Scale Signature Based on Heat Diffusion
%
% Copyright (c) 2013 Shuhua Li, Junjie Cao

queryPoints=eigvector1(landmark,:); % queryPoints(i,:), the coefficient vector of delta function in 3D mesh M
searchSpace = eigvector2;
atria = nn_prepare(searchSpace);

for i=1:nbr_iter   
    progressbar( i, nbr_iter );
    q = (C*queryPoints')'; 
    [refineIdx, distance] = nn_search(searchSpace,atria,q,1);    % refineIdx(i),T:M-N,refineIdx(i) is the index of the image point in N of query point i in M
    imagePoints=eigvector2(refineIdx,:);
    C=imagePoints'*queryPoints;
    [U,S,V]=svd(C);
    C=U*V';
end
clear searchSpace atria;