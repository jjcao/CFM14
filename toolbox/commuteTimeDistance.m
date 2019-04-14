function d = commuteTimeDistance(eigvector,eigvalue,i)

%Compute the commute time distance from i-th vertex
%%Input:  
%eigvector---the eigenvector of the Laplace-Beltrami matrix
%eigvalue---the first (k + 1) smallest eigvalues of the Laplace-Beltrami
%matrix
%i---the index of the vertex
%%Output: d---the commute time distance from the vertex i, d(j) is
%the commute time distance between vertex i and vertex j
%%Example:
%[V F] = mRead();
%[eigvector,eigvalue] = eigenDecoLaplacian(V,F,101);
%d = commuteTimeDistance(eigvector,eigvalue,1);
%showVertexFunction(V,F,d);

%Hui Wang, wanghui19841109@163.com or wanghui19841109@gmail.com, March.
%21,2011

eigvector = eigvector(:,2:end);
eigvalue = eigvalue(2:end);

n = size(eigvector,1);
matrix = -1.0 * speye(n);
matrix(:,i) = 1.0;
matrix(i,:) = 0.0;

M = matrix * eigvector;
M = M .^ 2;

eigvalue = eigvalue .^ -1;
d = M * eigvalue;
